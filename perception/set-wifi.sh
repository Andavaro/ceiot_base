SSID=$(grep "^#define WIFI_SSID" /home/andavaro/prueba/ceiot_base/perception/esp32-bmp280/config.h | rev | cut -d'"' -f 2 | rev)
PASSWORD=$(grep "^#define WIFI_PASSWORD" /home/andavaro/prueba/ceiot_base/perception/esp32-bmp280/config.h | rev | cut -d'"' -f 2 | rev)

sed -i -e 's/CONFIG_EXAMPLE_WIFI_SSID=".*/CONFIG_EXAMPLE_WIFI_SSID="'"${SSID}"'"/' /home/andavaro/prueba/ceiot_base/perception/esp32-bmp280/sdkconfig.ci
sed -i -e 's/CONFIG_EXAMPLE_WIFI_PASSWORD=".*/CONFIG_EXAMPLE_WIFI_PASSWORD="'"${PASSWORD}"'"/' /home/andavaro/prueba/ceiot_base/perception/esp32-bmp280/sdkconfig.ci
