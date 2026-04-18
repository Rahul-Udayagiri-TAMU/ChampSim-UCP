#include "partition_lru.h"

#include <algorithm>
#include <cassert>
#include <vector>

partition_lru::partition_lru(CACHE* cache) : partition_lru(cache, cache->NUM_SET, cache->NUM_WAY) {}

partition_lru::partition_lru(CACHE* cache, long sets, long ways)
    : replacement(cache), NUM_WAY(ways), last_used_cycles(static_cast<std::size_t>(sets * ways), 0)
{
  cache->set_ucp_mode();
}

long partition_lru::find_victim(uint32_t triggering_cpu, uint64_t instr_id, long set, const champsim::cache_block* current_set, champsim::address ip,
                                champsim::address full_addr, access_type type)
{
  auto begin = std::next(std::begin(last_used_cycles), set * NUM_WAY);
  auto end = std::next(begin, NUM_WAY);

  // Baseline behavior until partitioning is explicitly enabled
  if (!intern_->partitioning_enabled()) {
    auto victim = std::min_element(begin, end);
    assert(begin <= victim);
    assert(victim < end);
    return std::distance(begin, victim);
  }

  std::vector<long> legal_ways;
  const bool cpu_has_room = intern_->cpu_has_room_in_set(set, triggering_cpu);

  for (long way = 0; way < NUM_WAY; way++) {
    int32_t owner = intern_->get_line_owner(set, way);

    if (owner == static_cast<int32_t>(triggering_cpu)) {
      legal_ways.push_back(way);
    } else if (cpu_has_room) {
      legal_ways.push_back(way);
    }
  }

  // First fallback: evict one of this CPU's own lines
  if (legal_ways.empty()) {
    for (long way = 0; way < NUM_WAY; way++) {
      int32_t owner = intern_->get_line_owner(set, way);
      if (owner == static_cast<int32_t>(triggering_cpu)) {
        legal_ways.push_back(way);
      }
    }
  }

  // Last-resort fallback: behave like normal LRU
  if (legal_ways.empty()) {
    auto victim = std::min_element(begin, end);
    assert(begin <= victim);
    assert(victim < end);
    return std::distance(begin, victim);
  }

  long best_way = legal_ways.front();
  for (long way : legal_ways) {
    if (*(begin + way) < *(begin + best_way)) {
      best_way = way;
    }
  }

  return best_way;
}

void partition_lru::replacement_cache_fill(uint32_t triggering_cpu, long set, long way, champsim::address full_addr, champsim::address ip,
                                           champsim::address victim_addr, access_type type)
{
  last_used_cycles.at(static_cast<std::size_t>(set * NUM_WAY + way)) = cycle++;
}

void partition_lru::update_replacement_state(uint32_t triggering_cpu, long set, long way, champsim::address full_addr, champsim::address ip,
                                             champsim::address victim_addr, access_type type, uint8_t hit)
{
  if (hit && access_type{type} != access_type::WRITE) {
    last_used_cycles.at(static_cast<std::size_t>(set * NUM_WAY + way)) = cycle++;
  }
}
