#include <ESP8266WiFi.h>
// Levanta Wifi em modo Hotspot com nome de rede e definidos aqui abaixo

const char *ssid = "NomeDaRedeWifi"; // Aqui você definirá o nome da rede WIFI que você irá criar, a qual você se comunicará através do iPhone do exemplo.
const char *password = "Senha"; // Aqui será a senha da sua rede WIFI

//AP configuration
IPAddress apIP(192, 168, 1, 1);
IPAddress netMask(255, 255, 255, 0);
int lastSoftAPgetStationNum = -1;

void testConnected() {
  int connectedNum = WiFi.softAPgetStationNum();
  if (connectedNum != lastSoftAPgetStationNum) {
      Serial.println("Stations connected to soft-AP changed:");
      Serial.println(connectedNum);
      lastSoftAPgetStationNum = connectedNum;
      stopMotores();
  }
}

void setupAccessPoint() {
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, netMask);
  WiFi.softAP(ssid, password);
  delay(100);
}
