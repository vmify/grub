FROM alpine:3.16.0 AS build

ARG ARCH
ENV ARCH=$ARCH
ARG TAG
ENV TAG=$TAG

RUN apk add grub-efi
ADD build.sh /build/build.sh
ADD grub.license /build/LICENSE
RUN /build/build.sh


FROM scratch AS export
COPY --from=build /grub.tar.gz .
