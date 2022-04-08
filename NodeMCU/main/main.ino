#define LED D0
#define LIGADO LOW
#define DESLIGADO HIGH  

void setup()
{
 // Configura porta Serial
 Serial.begin(115200);
 
 // Configura o WIFI para rodar no modo AP (onde qualquer dispositivo pode se conectar a ele diretamente)
 setupAccessPoint();

 // Configura UDP (Começa a escutar informações pelo protocolo UDP)
 setupUDP();
 
  pinMode(LED, OUTPUT); 
  setupMotors();
}

void loop()
{
  // Verifica se tem alguma mensagem nova via UDP
  String mensagem = lerPacoteUDP();
  testConnected();
  
  if (mensagem == "1") { // Liga Led da própria NODEMCU
    digitalWrite(LED, LIGADO);
    Serial.println("Liga");
    Serial.println(mensagem);
  }
  else if (mensagem == "2") { // Desliga Led da própria NODEMCU
    digitalWrite(LED, DESLIGADO);
    Serial.println("Desliga");
    Serial.println(mensagem);
  }
  else if(stringContains(mensagem, "leftEsc")) {
      Serial.print("leftEsc : ");
      float value = getParameter(mensagem, ";").toFloat();
      Serial.println(value);
      updateLeftMotor(value);
  }
  else if(stringContains(mensagem, "rightEsc")) {
      Serial.print("rightEscEsc : ");
      float value = getParameter(mensagem, ";").toFloat();
      Serial.println(value);
      updateRightMotor(value);
  }
}
