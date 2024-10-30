package org.example;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface NewsletterRepository extends JpaRepository<Newsletter, Long> {
    // This method will automatically be implemented by Spring Data JPA
    Newsletter findByYearAndQuarter(Integer year, Integer quarter);
}