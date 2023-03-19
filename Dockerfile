FROM quay.io/keycloak/keycloak:20.0.5 as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KEYCLOAK_ADMIN=$KC_ADMIN_USER
ENV KEYCLOAK_ADMIN_PASSWORD=$KC_ADMIN_PASSWORD
ENV KC_DB=postgres

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:20.0.5
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:$KC_HOST,IP:127.0.0.1" -keystore conf/server.keystore

ENV KEYCLOAK_ADMIN=${KC_ADMIN_USER}
ENV KEYCLOAK_ADMIN_PASSWORD=${KC_ADMIN_PASSWORD}
ENV KC_DB=postgres
ENV KC_DB_URL=$KC_DB_URL
ENV KC_DB_USERNAME=$KC_DB_USERNAME
ENV KC_DB_PASSWORD=$KC_DB_PASSWORD
#ENV KC_HOSTNAME=$KC_HOST
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_PROXY=edge
ENV KC_HTTP_RELATIVE_PATH=/auth

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
