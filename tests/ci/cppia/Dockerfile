FROM haxe:4.3.7@sha256:f9c54774bad3d5fba0e3935af8d4d5ede5178d271e439c34394c02eadd922938
RUN apt-get update && apt-get install -y --no-install-recommends g++ make
ENV HXCPP_COMPILE_THREADS=4 HXCPP_NONINTERACTIVE=1
RUN haxelib install format 3.8.0 --quiet && haxelib install utest 1.13.2 --quiet
COPY build-host.sh hxcpp-array-compat.patch /opt/vision-cppia/
RUN bash /opt/vision-cppia/build-host.sh
WORKDIR /work
RUN haxelib dev vision /work
