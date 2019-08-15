package jp.pinkikki.eviroc.route

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.reactive.function.server.RouterFunction
import org.springframework.web.reactive.function.server.ServerResponse
import org.springframework.web.reactive.function.server.router
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono

@Configuration
class CoporunRouter {
    @Bean
    fun index(): RouterFunction<ServerResponse> =
            router {
                ("/coporuns").nest {
                    GET("/") {
                        ok().body(Flux.just(Coporun(1, "aruco", "4"), Coporun(2, "dainam", "5")), Coporun::class.java)
                    }
                    GET("/{id}") {
                        ok().body(Mono.just(Coporun(1, "aruco", "4")), Coporun::class.java)
                    }
                }
            }
}
