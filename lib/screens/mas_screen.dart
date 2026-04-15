import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/analytics_service.dart';
import '../theme/app_theme.dart';
import 'legal_screen.dart';

class MasScreen extends StatefulWidget {
  const MasScreen({super.key});

  @override
  State<MasScreen> createState() => _MasScreenState();
}

class _MasScreenState extends State<MasScreen> {
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  Future<void> _share() async {
    AnalyticsService.logShareApp();
    await Share.share(
      '¡Escucha Uninorte 103.1 FM Estéreo — Mueve la Cultura!\nhttps://www.uninorte.edu.co/web/uninorte-fm-estereo',
      subject: 'Uninorte FM',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Más',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),

          // App identity card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF1E1E1E)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.radio_rounded,
                        color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Uninorte FM',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '103.1 FM Estéreo · v$_version',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          const _SectionHeader('GENERAL'),
          _MenuItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Contacto',
            subtitle: 'Escríbenos por WhatsApp',
            iconColor: const Color(0xFF25D366),
            onTap: () {
              AnalyticsService.logContactTap();
              launchUrl(
                Uri.parse('https://wa.me/573233994626'),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          _MenuItem(
            icon: Icons.share_rounded,
            label: 'Compartir app',
            subtitle: 'Recomienda Uninorte FM',
            onTap: _share,
          ),

          const SizedBox(height: 24),

          const _SectionHeader('LEGAL'),
          _MenuItem(
            icon: Icons.description_outlined,
            label: 'Términos y Condiciones',
            subtitle: 'Condiciones de uso de la app',
            iconColor: Color(0xFF64B5F6),
            onTap: () {
              AnalyticsService.logLegalView('terminos');
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Términos y Condiciones',
                  content:
                      '''Responsable: Fundación Universidad del Norte, identificada con NIT 890.101.681-9 con domicilio en la ciudad de Barranquilla, Colombia, Km 5 Antigua Vía a Puerto Colombia, basededatos@uninorte.edu.co 3509509. Representante Legal Suplente: Alma Lucía Diaz Granados Meléndez, oficina_juridica@uninorte.edu.co. Fecha de entrada en vigencia de la política: agosto de 2013. Versión: 4

Fecha de la versión actual: 31 de mayo de 2023.

Interés legítimo del responsable que justifican el tratamiento de los datos recolectados por la Universidad: Ley 30 de 1992, Decreto 1075 de 2015, Decreto 2578 de 2012, Decreto 722 de 2013.

Oficial de Protección de Datos: Andrés Vélez Menco. amenco@uninorte.edu.co En el ejercicio natural de sus actividades, la FUNDACIÓN UNIVERSIDAD DEL NORTE (en adelante la UNIVERSIDAD) podrá realizar recolección, uso y tratamiento de datos personales de los miembros de su comunidad entendiendo por estos a estudiantes, docentes, conferencistas, empleados y egresados (en adelante los USUARIOS). Además de la información concerniente a los miembros de la comunidad universitaria, podrán hacer parte de tales bases de datos la información personal de exempleados, invitados, proveedores y visitantes de la UNIVERSIDAD en los mismos términos consagrados en esta política, los cuales, para efectos de este documento, también se entienden como USUARIOS.

El uso, recolección, tratamiento y finalidad del mismo de datos personales en las bases de datos de la UNIVERSIDAD se sujetarán a las siguientes políticas:

1. Las bases de datos, o los distintos tipos de repositorios electrónicos, son creaciones intelectuales sujetas a la protección del Derecho de Autor. La UNIVERSIDAD es la titular de las bases de datos que utiliza, para lo cual se sujeta plenamente a las normas sobre protección de datos personales y Habeas Data. En consecuencia, la UNIVERSIDAD, como encargada y responsable del tratamiento, no suministrará la misma a terceros salvo en los casos autorizados por el Titular y según lo establecido en el numeral 9 de la presente política.

2. La finalidad para la recolección, uso y tratamiento de datos personales a que se refiere esta política es la adecuada gestión, administración, mejora de las actividades y distintos servicios de la UNIVERSIDAD, realización de procesos internos, estadísticas, análisis cuantitativo y cualitativo de las 4 actividades, tales como uso del campus o de los servicios ofrecidos por la UNIVERSIDAD, entre otros que resulten de interés para la institución. Igualmente podrá referirse al ofrecimiento de nuevos productos o mejora de los existentes que puedan contribuir con el bienestar académico, administrativo, financiero o de formación, ofrecidos por la UNIVERSIDAD o por terceros relacionados con su objeto.

3. La UNIVERSIDAD podrá suministrar información personal contenida en sus bases de datos, relacionada con su objeto a pares académicos o entidades certificadoras nacionales o internacionales.

4. Al autorizar la recolección de datos de carácter personal a la UNIVERSIDAD, mediante la implementación de formularios de recolección de datos o su envío a través de cualquier otro medio, los USUARIOS declaran aceptar plenamente y sin reservas la incorporación de los datos facilitados y su tratamiento, en los términos estipulados en esta política.

5. Las bases de datos en las que se incluye información de los titulares tendrán una vigencia igual al tiempo en que se mantenga y se utilice la información para las finalidades descritas en esta política, y determinada por la permanente operación de la UNIVERSIDAD, de acuerdo con su naturaleza fundacional, su misión institucional de docencia, investigación y extensión, así como las actividades propias de la operación administrativa general. Asimismo, los datos personales suministrados también se conservarán mientras se mantenga la relación contractual con el titular de la información, e incluso mientras exista un deber legal de conservación.

6. Las bases de datos que obtenga la Universidad por parte de entidades del Estado, sean autoridades nacionales o territoriales, en ejecución o cumplimiento de políticas o programas de beneficio general, serán objeto de tratamiento en los términos establecidos por éstas y conforme a las funciones legales que ejerzan.

7.Los USUARIOS son los únicos responsables de que la información suministrada a la UNIVERSIDAD sea totalmente actual, exacta y veraz y reconocen su obligación de mantenerla actualizada. En todo caso, los USUARIOS son los únicos responsables de la información falsa o inexacta que suministren y de los perjuicios que cause o pueda causar a la UNIVERSIDAD o a terceros por el uso de tal información.

8. La UNIVERSIDAD se sujeta plenamente a las directrices de la Ley, así como a sus reglamentos y políticas internas, por lo cual tratará con extrema diligencia la información personal y dará el mejor uso posible a la información recaudada por medios físicos o electrónicos que integrarán sus bases datos o cualquier clase de repositorio digital.

9. El USUARIO reconoce que el ingreso de información personal lo realiza de manera voluntaria y acepta que a través de cualquier trámite, por los canales habilitados para ello por la UNIVERSIDAD, puedan recogerse datos personales, los cuales no se cederán a terceros sin su consentimiento, salvo que se trate, conforme a la ley, de información requerida por una entidad pública o administrativa en ejercicio de sus funciones legales o por orden judicial; datos de naturaleza pública; en casos de urgencia médica o sanitaria; para fines históricos, estadísticos o científicos; cuando medie la existencia de convenios de cooperación interinstitucional a través de los cuales se desarrollen o cumplan objetivos académicos; cuando el operador de la base de datos tenga la misma finalidad o esté comprendida dentro de esta, permitiendo el cabal cumplimiento de los objetivos de la UNIVERSIDAD haciendo uso de servicios ofrecidos por terceros que apoyen la operación institucional. 

10. Al facilitar datos de carácter personal, el USUARIO acepta plenamente la remisión de información promocional o comercial, noticias, cursos, eventos, boletines, congresos y en general productos relacionados con la UNIVERSIDAD.

11. Los USUARIOS podrán ejercitar, en cualquier momento, los derechos de acceso, actualización, rectificación y supresión de sus datos personales, así como la revocación de la autorización otorgada a la Universidad y ejercer cualquier otro derecho derivado o relacionado con la protección de datos personales (habeas data). Para ello se tendrán en cuenta el siguiente procedimiento:

a. El área encargada de la atención de peticiones, consultas y reclamos ante la cual el titular de la información puede ejercer sus derechos es la Dirección de Tecnología Informática y de Comunicaciones.

b. El ejercicio de estos derechos podrá efectuarse mediante el diligenciamiento del formulario en la página web de la Universidad en la URL: https://www.uninorte.edu.co/solicitud-consulta-reclamo-informacion-personal o de manera personal en la Dirección de Tecnología Informática ubicada en el Primer piso, bloque B, en el km 5 antigua vía a Puerto Colombia.

c. En caso de que la persona tenga habilitado un correo asignado por la Universidad (del tipo @uninorte.edu.co), la respuesta a la solicitud se enviará a dicha dirección. Igualmente, la Universidad podrá dar respuesta a correos distintos a Uninorte siempre y cuando se encuentren registrados en las bases de datos institucionales.

d. La respuesta a toda solicitud relacionada con acceso, actualización, rectificación y supresión de sus datos personales, así como la revocación de la autorización otorgada a la UNIVERSIDAD o el ejercicio de cualquier otro derecho derivado o relacionado con la protección de datos personales (habeas data) se dará en el término de diez (10) días hábiles.

Si la persona no está de acuerdo con la información que reposa en las bases de datos de la UNIVERSIDAD debe acreditar con las pruebas que tenga en su haber la información que solicita se debe modificar.

12. Con relación a los datos sensibles que recolecte la Universidad entendidos como aquellos que pueden llegar a afectar la intimidad del Titular o cuyo uso indebido pueda generar su discriminación, tales como los que revelen el origen racial o étnico, la orientación política, las convicciones religiosas o filosóficas, la pertenencia a sindicatos, organizaciones sociales, de derechos humanos o que promueva intereses de cualquier partido político o que garanticen los derechos y garantías de partidos políticos de oposición así como los datos relativos a la salud, a la vida sexual y los datos biométricos; el titular tendrá el derecho a abstenerse de suministrar la información solicitada.

13. Sin menoscabo de los derechos constitucionales y las disposiciones legales y reglamentarias, la UNIVERSIDAD se reserva el derecho de modificar en cualquier momento su política de uso y tratamiento de información personal, privacidad y confidencialidad de la información existente en las bases de datos de la UNIVERSIDAD, manteniendo el debido respeto por la leyes de protección de datos personales e informando, cuando se trate de cambios sustanciales, a todos los interesados a través de cualquier mecanismo de difusión dirigida o masiva no dirigida.

Las bases de datos estarán alojadas en el centro de datos de la UNIVERSIDAD o en la modalidad de servicios de computación en la nube que prestan terceros expertos dedicados profesionalmente a tal actividad.

La UNIVERSIDAD ha dispuesto recursos humanos y tecnológicos para proteger la confidencialidad, integridad y disponibilidad de la información y de sus bases de datos.

Las copias de las bases de datos son igualmente controladas y están protegidas con mecanismos de seguridad que garantizan su confidencialidad, integridad y disponibilidad.

Su uso está limitado y restringido a personal autorizado por los responsables de las bases de datos y de acuerdo con sus funciones y roles. Existen procesos y procedimientos que gestionan la autenticación, la autorización y la auditoría del acceso a las mismas, regidos por las políticas institucionales de seguridad informática.

Así mismo, se garantizan los derechos de eliminación, actualización o rectificación de la información personal de acuerdo con los derechos de los titulares en las bases de datos vigentes cuando estos sean procedentes. En todo caso, las copias parciales serán eliminadas una vez culmine la finalidad de su tratamiento interno.

El área de Seguridad Informática de la Dirección de Tecnología Informática y de Comunicaciones de la UNIVERSIDAD es la responsable de planear, implementar y mantener la seguridad y continuidad de los activos de información de los productos TIC que soportan los procesos administrativos y académicos de la UNIVERSIDAD.

Para cumplir con esta misión, la institución cuenta con un firewall, un sistema de prevención de intrusos, una solución para gestión de vulnerabilidades técnicas, una solución para protección de código malicioso, planes de contingencia para los productos críticos y procedimientos para gestión de incidentes de seguridad.

Además, se tienen implementados mecanismos de seguridad para el acceso a las bases de datos, el cual es restringido y está definido de acuerdo con políticas institucionales, y es monitoreado y revisado periódicamente. En ese sentido, la UNIVERSIDAD ha implementado mecanismos que proporcionan seguridad a la información recaudada y dispone sus mejores esfuerzos para procurar de manera diligente y prudente el mantenimiento de tal seguridad; no obstante, el USUARIO reconoce que la administración de las bases de datos puede implicar un nivel de riesgo, el cual asume y acepta y, por consiguiente, la UNIVERSIDAD no otorga ninguna garantía ni asume ninguna obligación o responsabilidad por pérdida o sustracción de información de su sistema informático.

14. En el caso de los servicios contratados en la nube, la UNIVERSIDAD realizará sus mejores esfuerzos técnicos para asegurarse de que dicho servicio proporcione una debida protección de los datos, que sea prestado por profesionales en el área y posea los mecanismos tecnológicos que garanticen de una manera razonable la confidencialidad, integridad y disponibilidad de la información.

15. Mientras se navegue en el sitio web de la UNIVERSIDAD, pueden ser insertadas cookies en el navegador de los usuarios con el objetivo de entender temas de preferencia y presentar publicidad en otros sitios, basado en la interacción previa que hayan tenido con el sitio web institucional. Las cookies no recogen ninguna información personal como nombre, dirección de correo electrónico, dirección postal, teléfono ni dirección. Si los usuarios no desean que las cookies queden almacenadas en sus equipos estas pueden ser desconectadas en su navegador.

16. Todas y cada una de las personas que administran, manejen, actualicen o tengan acceso a informaciones de cualquier tipo que se encuentre en Bases de Datos de la UNIVERSIDAD, o cualquier clase de repositorios electrónicos, se comprometen a conservarla y mantenerla de manera estrictamente confidencial y no revelarla a terceros.

Esta obligación cobija todas las informaciones personales, contables, técnicas, comerciales o de cualquier otro tipo suministradas en la ejecución y ejercicio de sus funciones, incluyendo de manera enunciativa y no taxativa las fórmulas, procedimientos, técnicas, know - how y demás informaciones en general a que puedan tener acceso.''', // TODO: añadir el texto aquí
                ),
              ),
            );
            },
          ),
          _MenuItem(
            icon: Icons.shield_outlined,
            label: 'Política de Privacidad',
            subtitle: 'Cómo tratamos tus datos',
            iconColor: Color(0xFF81C784),
            onTap: () {
              AnalyticsService.logLegalView('privacidad');
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LegalScreen(
                  title: 'Política de Privacidad',
                  content:
                      '''Responsable: Fundación Universidad del Norte, identificada con NIT 890.101.681-9 con domicilio en la ciudad de Barranquilla, Colombia, Km 5 Antigua Vía a Puerto Colombia, basededatos@uninorte.edu.co 3509509. Representante Legal Suplente: Beatriz Vergara, oficina_juridica@uninorte.edu.co.


Fecha de la versión actual: 31 de mayo de 2023.


Interés legítimo del responsable que justifican el tratamiento de los datos recolectados por la Universidad: Ley 30 de 1992, Decreto 1075 de 2015, Decreto 2578 de 2012, Decreto 722 de 2013.


En el ejercicio natural de sus actividades, la FUNDACIÓN UNIVERSIDAD DEL NORTE (en adelante la UNIVERSIDAD) podrá realizar recolección, uso y tratamiento de datos personales de los miembros de su comunidad entendiendo por estos a estudiantes, docentes, conferencistas, empleados y egresados (en adelante los USUARIOS). Además de la información concerniente a los miembros de la comunidad universitaria, podrán hacer parte de tales bases de datos la información personal de exempleados, invitados, proveedores y visitantes de la UNIVERSIDAD en los mismos términos consagrados en esta política, los cuales, para efectos de este documento, también se entienden como USUARIOS.


El uso, recolección, tratamiento y finalidad del mismo de datos personales en las bases de datos de la UNIVERSIDAD se sujetarán a las siguientes políticas:


1. Las bases de datos, o los distintos tipos de repositorios electrónicos, son creaciones intelectuales sujetas a la protección del Derecho de Autor. La UNIVERSIDAD es la titular de las bases de datos que utiliza, para lo cual se sujeta plenamente a las normas sobre protección de datos personales y Habeas Data. En consecuencia, la UNIVERSIDAD, como encargada y responsable del tratamiento, no suministrará la misma a terceros salvo en los casos autorizados por el Titular y según lo establecido en el numeral 9 de la presente política.


2. La finalidad para la recolección, uso y tratamiento de datos personales a que se refiere esta política es la adecuada gestión, administración, mejora de las actividades y distintos servicios de la UNIVERSIDAD, realización de procesos internos, estadísticas, análisis cuantitativo y cualitativo de las 4 actividades, tales como uso del campus o de los servicios ofrecidos por la UNIVERSIDAD, entre otros que resulten de interés para la institución. Igualmente podrá referirse al ofrecimiento de nuevos productos o mejora de los existentes que puedan contribuir con el bienestar académico, administrativo, financiero o de formación, ofrecidos por la UNIVERSIDAD o por terceros relacionados con su objeto.


3. La UNIVERSIDAD podrá suministrar información personal contenida en sus bases de datos, relacionada con su objeto a pares académicos o entidades certificadoras nacionales o internacionales.


4. Al autorizar la recolección de datos de carácter personal a la UNIVERSIDAD, mediante la implementación de formularios de recolección de datos o su envío a través de cualquier otro medio, los USUARIOS declaran aceptar plenamente y sin reservas la incorporación de los datos facilitados y su tratamiento, en los términos estipulados en esta política.


5. Las bases de datos en las que se incluye información de los titulares tendrán una vigencia igual al tiempo en que se mantenga y se utilice la información para las finalidades descritas en esta política, y determinada por la permanente operación de la UNIVERSIDAD, de acuerdo con su naturaleza fundacional, su misión institucional de docencia, investigación y extensión, así como las actividades propias de la operación administrativa general. Asimismo, los datos personales suministrados también se conservarán mientras se mantenga la relación contractual con el titular de la información, e incluso mientras exista un deber legal de conservación.


6. Las bases de datos que obtenga la Universidad por parte de entidades del Estado, sean autoridades nacionales o territoriales, en ejecución o cumplimiento de políticas o programas de beneficio general, serán objeto de tratamiento en los términos establecidos por éstas y conforme a las funciones legales que ejerzan.


7.Los USUARIOS son los únicos responsables de que la información suministrada a la UNIVERSIDAD sea totalmente actual, exacta y veraz y reconocen su obligación de mantenerla actualizada. En todo caso, los USUARIOS son los únicos responsables de la información falsa o inexacta que suministren y de los perjuicios que cause o pueda causar a la UNIVERSIDAD o a terceros por el uso de tal información.


8. La UNIVERSIDAD se sujeta plenamente a las directrices de la Ley, así como a sus reglamentos y políticas internas, por lo cual tratará con extrema diligencia la información personal y dará el mejor uso posible a la información recaudada por medios físicos o electrónicos que integrarán sus bases datos o cualquier clase de repositorio digital.


9. El USUARIO reconoce que el ingreso de información personal lo realiza de manera voluntaria y acepta que a través de cualquier trámite, por los canales habilitados para ello por la UNIVERSIDAD, puedan recogerse datos personales, los cuales no se cederán a terceros sin su consentimiento, salvo que se trate, conforme a la ley, de información requerida por una entidad pública o administrativa en ejercicio de sus funciones legales o por orden judicial; datos de naturaleza pública; en casos de urgencia médica o sanitaria; para fines históricos, estadísticos o científicos; cuando medie la existencia de convenios de cooperación interinstitucional a través de los cuales se desarrollen o cumplan objetivos académicos; cuando el operador de la base de datos tenga la misma finalidad o esté comprendida dentro de esta, permitiendo el cabal cumplimiento de los objetivos de la UNIVERSIDAD haciendo uso de servicios ofrecidos por terceros que apoyen la operación institucional. 


10. Al facilitar datos de carácter personal, el USUARIO acepta plenamente la remisión de información promocional o comercial, noticias, cursos, eventos, boletines, congresos y en general productos relacionados con la UNIVERSIDAD.


11. Los USUARIOS podrán ejercitar, en cualquier momento, los derechos de acceso, actualización, rectificación y supresión de sus datos personales, así como la revocación de la autorización otorgada a la Universidad y ejercer cualquier otro derecho derivado o relacionado con la protección de datos personales (habeas data). Para ello se tendrán en cuenta el siguiente procedimiento:


a. El área encargada de la atención de peticiones, consultas y reclamos ante la cual el titular de la información puede ejercer sus derechos es la Dirección de Tecnología Informática y de Comunicaciones.


b. El ejercicio de estos derechos podrá efectuarse mediante el diligenciamiento del formulario en la página web de la Universidad en la URL: https://www.uninorte.edu.co/solicitud-consulta-reclamo-informacion-personal o de manera personal en la Dirección de Tecnología Informática ubicada en el Primer piso, bloque B, en el km 5 antigua vía a Puerto Colombia.


c. En caso de que la persona tenga habilitado un correo asignado por la Universidad (del tipo @uninorte.edu.co), la respuesta a la solicitud se enviará a dicha dirección. Igualmente, la Universidad podrá dar respuesta a correos distintos a Uninorte siempre y cuando se encuentren registrados en las bases de datos institucionales.


d. La respuesta a toda solicitud relacionada con acceso, actualización, rectificación y supresión de sus datos personales, así como la revocación de la autorización otorgada a la UNIVERSIDAD o el ejercicio de cualquier otro derecho derivado o relacionado con la protección de datos personales (habeas data) se dará en el término de diez (10) días hábiles.


Si la persona no está de acuerdo con la información que reposa en las bases de datos de la UNIVERSIDAD debe acreditar con las pruebas que tenga en su haber la información que solicita se debe modificar.


12. Con relación a los datos sensibles que recolecte la Universidad entendidos como aquellos que pueden llegar a afectar la intimidad del Titular o cuyo uso indebido pueda generar su discriminación, tales como los que revelen el origen racial o étnico, la orientación política, las convicciones religiosas o filosóficas, la pertenencia a sindicatos, organizaciones sociales, de derechos humanos o que promueva intereses de cualquier partido político o que garanticen los derechos y garantías de partidos políticos de oposición así como los datos relativos a la salud, a la vida sexual y los datos biométricos; el titular tendrá el derecho a abstenerse de suministrar la información solicitada.


13. Sin menoscabo de los derechos constitucionales y las disposiciones legales y reglamentarias, la UNIVERSIDAD se reserva el derecho de modificar en cualquier momento su política de uso y tratamiento de información personal, privacidad y confidencialidad de la información existente en las bases de datos de la UNIVERSIDAD, manteniendo el debido respeto por la leyes de protección de datos personales e informando, cuando se trate de cambios sustanciales, a todos los interesados a través de cualquier mecanismo de difusión dirigida o masiva no dirigida.


Las bases de datos estarán alojadas en el centro de datos de la UNIVERSIDAD o en la modalidad de servicios de computación en la nube que prestan terceros expertos dedicados profesionalmente a tal actividad.


La UNIVERSIDAD ha dispuesto recursos humanos y tecnológicos para proteger la confidencialidad, integridad y disponibilidad de la información y de sus bases de datos.


Las copias de las bases de datos son igualmente controladas y están protegidas con mecanismos de seguridad que garantizan su confidencialidad, integridad y disponibilidad.


Su uso está limitado y restringido a personal autorizado por los responsables de las bases de datos y de acuerdo con sus funciones y roles. Existen procesos y procedimientos que gestionan la autenticación, la autorización y la auditoría del acceso a las mismas, regidos por las políticas institucionales de seguridad informática.


Así mismo, se garantizan los derechos de eliminación, actualización o rectificación de la información personal de acuerdo con los derechos de los titulares en las bases de datos vigentes cuando estos sean procedentes. En todo caso, las copias parciales serán eliminadas una vez culmine la finalidad de su tratamiento interno.


El área de Seguridad Informática de la Dirección de Tecnología Informática y de Comunicaciones de la UNIVERSIDAD es la responsable de planear, implementar y mantener la seguridad y continuidad de los activos de información de los productos TIC que soportan los procesos administrativos y académicos de la UNIVERSIDAD.


Para cumplir con esta misión, la institución cuenta con un firewall, un sistema de prevención de intrusos, una solución para gestión de vulnerabilidades técnicas, una solución para protección de código malicioso, planes de contingencia para los productos críticos y procedimientos para gestión de incidentes de seguridad.


Además, se tienen implementados mecanismos de seguridad para el acceso a las bases de datos, el cual es restringido y está definido de acuerdo con políticas institucionales, y es monitoreado y revisado periódicamente. En ese sentido, la UNIVERSIDAD ha implementado mecanismos que proporcionan seguridad a la información recaudada y dispone sus mejores esfuerzos para procurar de manera diligente y prudente el mantenimiento de tal seguridad; no obstante, el USUARIO reconoce que la administración de las bases de datos puede implicar un nivel de riesgo, el cual asume y acepta y, por consiguiente, la UNIVERSIDAD no otorga ninguna garantía ni asume ninguna obligación o responsabilidad por pérdida o sustracción de información de su sistema informático.


14. En el caso de los servicios contratados en la nube, la UNIVERSIDAD realizará sus mejores esfuerzos técnicos para asegurarse de que dicho servicio proporcione una debida protección de los datos, que sea prestado por profesionales en el área y posea los mecanismos tecnológicos que garanticen de una manera razonable la confidencialidad, integridad y disponibilidad de la información.


15. Mientras se navegue en el sitio web de la UNIVERSIDAD, pueden ser insertadas cookies en el navegador de los usuarios con el objetivo de entender temas de preferencia y presentar publicidad en otros sitios, basado en la interacción previa que hayan tenido con el sitio web institucional. Las cookies no recogen ninguna información personal como nombre, dirección de correo electrónico, dirección postal, teléfono ni dirección. Si los usuarios no desean que las cookies queden almacenadas en sus equipos estas pueden ser desconectadas en su navegador.


16. Todas y cada una de las personas que administran, manejen, actualicen o tengan acceso a informaciones de cualquier tipo que se encuentre en Bases de Datos de la UNIVERSIDAD, o cualquier clase de repositorios electrónicos, se comprometen a conservarla y mantenerla de manera estrictamente confidencial y no revelarla a terceros.


Esta obligación cobija todas las informaciones personales, contables, técnicas, comerciales o de cualquier otro tipo suministradas en la ejecución y ejercicio de sus funciones, incluyendo de manera enunciativa y no taxativa las fórmulas, procedimientos, técnicas, know - how y demás informaciones en general a que puedan tener acceso.''', // TODO: añadir el texto aquí
                ),
              ),
            );
            },
          ),

          const SizedBox(height: 24),

          // Version footer
          Center(
            child: Text(
              'Uninorte FM v$_version',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white.withOpacity(0.35),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E1E1E)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.2), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
