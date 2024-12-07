---
layout: post
title: "如何理解 SaaS 并实践"
date: 2024-12-08

---

<div class="mermaid">
graph TB
    subgraph "Client Layer"
        B[Browser]
        M[Mobile Web]
    end

    subgraph "Frontend Layer"
        R[SvelteKit Router]
        subgraph "Public Routes"
            PR1["dealers/:dealerId"]
            PR2["api/inventory/:userId"]
            PR3["inventory/:userId"]
        end
        subgraph "Admin Routes"
            AR1["account/vehicles"]
            AR2["account/models"]
            AR3["account/page-settings"]
        end
    end

    subgraph "Backend Layer"
        SK[SvelteKit Server]
        Auth[Supabase Auth]
        RLS[Row Level Security]
    end

    subgraph "Database Layer"
        subgraph "Supabase PostgreSQL"
            T1[(dealer_pages)]
            T2[(inventory_vehicles)]
            T3[(models)]
            T4[(manufacturers)]
            T5[(body_types)]
            T6[(profiles)]
        end
    end

    B --> R
    M --> R
    R --> PR1 & PR2 & PR3
    R --> AR1 & AR2 & AR3
    
    PR1 & PR2 & PR3 --> SK
    AR1 & AR2 & AR3 --> SK
    
    SK --> Auth
    SK --> RLS
    
    RLS --> T1
    RLS --> T2
    RLS --> T3
    RLS --> T4
    RLS --> T5
    RLS --> T6

    %% Data relationships
    T2 --> T3
    T3 --> T4
    T2 --> T5

    classDef public fill:#90EE90
    classDef admin fill:#FFB6C1
    classDef security fill:#FFD700
    classDef database fill:#87CEEB

    class PR1,PR2,PR3 public
    class AR1,AR2,AR3 admin
    class Auth,RLS security
    class T1,T2,T3,T4,T5,T6 database
</div>
