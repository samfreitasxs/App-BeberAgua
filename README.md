#  Lembrete de Água

Bem-vindo ao Lembrete de Água, um aplicativo simples e intuitivo para iOS que ajuda você a manter-se hidratado ao longo do dia! Com lembretes personalizáveis e um acompanhamento visual do seu progresso, cuidar da sua saúde nunca foi tão fácil.

##  Funcionalidades

* **Lembretes Personalizados:** Receba notificações para beber água em intervalos de 5, 10, 20, 30, 60, 90 ou 120 minutos, configuráveis para iniciar e parar em horários específicos do dia.
* **Interatividade com Notificações:** Registre um copo de água diretamente da notificação push com botões "Sim" ou "Não", sem precisar abrir o app.
* **Acompanhamento Visual:** Observe um ícone de humano se "encher" de água à medida que você registra seus copos, oferecendo uma representação clara do seu nível de hidratação diária.
* **Meta Diária:** Defina sua meta de copos de água por dia e acompanhe seu progresso.
* **Resumo Diário:** Receba um resumo automático às 18h com a quantidade total de água que você consumiu no dia.
* **Design Amigável:** Interface limpa e fácil de usar, focada na sua experiência de hidratação.

##  Como Usar

1.  **Instale o Aplicativo:** Faça o build e rode o aplicativo no seu iPhone ou simulador.
2.  **Defina sua Meta:** Na tela principal, você verá um contador para sua meta diária de copos.
3.  **Registre sua Água:** Use os botões `+` e `-` para adicionar ou remover copos de água.
4.  **Configure os Lembretes:**
    * Toque no ícone de **engrenagem (⚙️)** no canto superior direito para acessar as configurações.
    * **Ative os Lembretes.**
    * Escolha o **intervalo** de tempo para os lembretes (e.g., a cada 30 minutos).
    * Defina as **horas de início e fim** para os lembretes.
    * Clique em "Salvar e Reagendar Lembretes" para aplicar as alterações.
5.  **Interaja com Notificações:** Quando um lembrete aparecer, pressione e segure na notificação para revelar as opções "Sim, tomei!" e "Não tomei". Selecione "Sim" para registrar automaticamente sua ingestão de água.
6.  **Acompanhe o Resumo:** Fique atento à notificação de resumo que será entregue diariamente às 18h.

##  Tecnologias Utilizadas

* **SwiftUI:** Para a construção da interface do usuário.
* **UserNotifications Framework:** Para agendamento e gerenciamento de notificações.
* **AppStorage:** Para persistência de dados simples do usuário.
* **Notification Content Extension:** Para personalizar a interface das notificações interativas.
* **Notification Service Extension:** Para modificar o conteúdo das notificações (e.g., o resumo diário).

##  Configuração do Ambiente de Desenvolvimento

Para rodar este projeto:

1.  **Xcode:** Certifique-se de ter o Xcode instalado (versão 14.0 ou superior recomendada).
2.  **Clone o Repositório:**
    ```bash
    git clone [URL_DO_SEU_REPOSITORIO_AQUI]
    cd LembreteDeAgua
    ```
3.  **Abra o Projeto:** Abra o arquivo `.xcodeproj` no Xcode.
4.  **Configurações de App Group:**
    * Vá em `TomarAgua` (o target principal) > `Signing & Capabilities` > `+ Capability` > `App Groups`.
    * Crie um App Group (e.g., `group.com.seunome.TomarAgua`) e certifique-se de que ele esteja marcado.
    * Repita este processo para os targets `WaterNotificationUI` e `WaterSummaryService`, usando o **MESMO** App Group.
5.  **Substitua o App Group no Código:** Atualize todas as instâncias de `UserDefaults(suiteName: "group.com.seunome.TomarAgua")` no código para usar o identificador do seu App Group.
6.  **Build & Run:** Selecione um dispositivo ou simulador e rode o aplicativo (`Product > Run` ou `Command + R`).

##  Observações de Desenvolvimento

* Este projeto utiliza um `AppDelegate` customizado com `@UIApplicationDelegateAdaptor` para lidar com as notificações em um projeto Pure SwiftUI.
* A animação do ícone de humano foi ajustada para o `person.fill` do SF Symbols. Ajustes finos nos valores de `frame` e `clipShape` dentro de `HumanHydrationView` podem ser necessários para um preenchimento perfeito em diferentes dispositivos.

## 🧑‍💻 Contribuição

Contribuições são bem-vindas\! Se você encontrou um bug, tem uma sugestão de recurso ou gostaria de melhorar o código, sinta-se à vontade para abrir uma issue ou enviar um pull request.

## 📧 Contato

Samuel Freitas - samuelSoftwareEngineer@proton.me

---

##  Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

Copyright (c) 2025 Samuel freitas



