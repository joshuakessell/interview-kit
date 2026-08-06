---
name: spring-fast
description: Scaffold and build a Java Spring Boot API fast for a timed build. Use when the assignment requires Java, Spring, Spring Boot, JPA, Maven, or a JVM backend.
---

# Spring Boot in a Timed Build

## Scaffold (no IDE wizard needed)

```bash
curl -s https://start.spring.io/starter.tgz \
  -d type=maven-project -d language=java -d name=app \
  -d dependencies=web,data-jpa,h2,postgresql,validation | tar -xzf -
./mvnw spring-boot:run   # http://localhost:8080
```

Requires a JDK (17+). `java -version` first; if the sandbox lacks one, `sdk install java`
via SDKMAN or ask the interviewer — a Java assignment on a machine without Java is their
problem to solve, not yours to hide.

## Database strategy: H2 first, Postgres by three properties

Start on H2 in-memory — zero provisioning, app boots instantly:

```properties
spring.datasource.url=jdbc:h2:mem:app
spring.jpa.hibernate.ddl-auto=update
```

When the core loop works, flip to real Postgres (Neon string) by swapping url/username/
password. `ddl-auto=update` is the interview setting — NARRATE: "in production this is
Flyway migrations; update-mode is my conscious speed tradeoff today."

## Minimal vertical slice (entity → repo → controller)

```java
@Entity class Item {
  @Id @GeneratedValue Long id;
  String title;
  // getters/setters
}
interface ItemRepo extends JpaRepository<Item, Long> {}

@RestController @RequestMapping("/api/items")
class ItemController {
  private final ItemRepo repo;
  ItemController(ItemRepo repo) { this.repo = repo; }
  @GetMapping List<Item> all() { return repo.findAll(); }
  @PostMapping Item create(@RequestBody Item i) { return repo.save(i); }
}
```

Constructor injection, no Lombok (one less thing to break), no service layer until two
controllers need shared logic — in a 2-hour build they won't.

## If a Next/React frontend calls this API

CORS will bite immediately. Fastest fix: `@CrossOrigin(origins = "*")` on the controller
for the demo, NARRATE the production answer (explicit origins in a WebMvcConfigurer).

## Testing

`@WebMvcTest` + MockMvc for controller slices — boots in seconds. `@SpringBootTest` boots
the world; skip it under a clock.
