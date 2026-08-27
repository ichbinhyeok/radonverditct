package com.radonverdict.repository;

import com.radonverdict.model.entity.PlanShare;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.time.Instant;

public interface PlanShareRepository extends JpaRepository<PlanShare, Long> {
    Optional<PlanShare> findByTokenHash(String tokenHash);
    long deleteByExpiresAtBefore(Instant cutoff);
}
