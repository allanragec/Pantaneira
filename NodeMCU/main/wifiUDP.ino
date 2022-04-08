#include <WiFiUdp.h>

WiFiUDP Udp;
int localPort = 9999;
char emptyBuffer[0];
int lastUdpIsAvailable = -10;

void setupUDP() {
  // Começa a escutar informações na porta configurada
  Udp.begin(localPort);
}

String lerPacoteUDP() {
  // Verifica o tamnho do pacote disponível
  int packetSize = Udp.parsePacket();
//  Serial.print("packetSize: ");
//      Serial.println(packetSize);
  char packetBuffer[255];
  int udpIsAvailable = Udp.available();
  if (lastUdpIsAvailable != udpIsAvailable) {
      Serial.print("udpIsAvailable changed: ");
      Serial.println(udpIsAvailable);
      lastUdpIsAvailable = udpIsAvailable;
  }


  if (packetSize) {
    // Lê o pacote
    int len = Udp.read(packetBuffer, 255);
    if (len > 0) packetBuffer[len] = 0;
    Serial.print("Recebido(IP/Tamanho/Dado): ");
    Serial.print(Udp.remoteIP()); Serial.print(" / ");
    Serial.print(packetSize); Serial.print(" / ");
    Serial.println(packetBuffer);

    Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    // Informa que o dado foi recebido com sucesso
    Udp.write("dado recebido: ");
    Udp.write(packetBuffer);
    Udp.endPacket();

    // retorna o pacote
    return packetBuffer;
  }

  return emptyBuffer;
}
