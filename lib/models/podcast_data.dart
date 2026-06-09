import 'package:flutter/material.dart';

class Episode {
  final String title;
  final String embedUrl;

  /// Optional short description shown en la pantalla de detalle.
  final String description;

  const Episode({
    required this.title,
    required this.embedUrl,
    this.description = '',
  });
}

class Show {
  final String id;
  final String name;
  final Color color;
  final String coverUrl;

  /// Descripción corta del show, usada en la tarjeta de categoría.
  final String description;
  final List<Episode> episodes;

  const Show({
    required this.id,
    required this.name,
    required this.color,
    this.coverUrl = '',
    this.description = '',
    required this.episodes,
  });
}

const kShows = [
  Show(
      id: 'tardeando',
      name: 'Tardeando',
      color: Color.fromARGB(255, 244, 6, 2),
      coverUrl: '',
      description:
          'Cultura, ideas y conversaciones que hacen más interesante la tarde.',
      episodes: [
        Episode(
            title: 'Brasileirices :: Piseiro: del aboio a la pisadinha',
            embedUrl:
                'https://open.spotify.com/embed/episode/10lMzvhQQE3krBMvvWkJNB?utm_source=generator'),
        Episode(
            title:
                'Así Suena Colombia :: Aria Vega y el pulso musical del Caribe colombiano',
            embedUrl:
                'https://open.spotify.com/embed/episode/5ZzanKkJQk9m2aolUZrlha?utm_source=generator'),
        Episode(
            title: 'Brasileirices :: Historia del Forró',
            embedUrl:
                'https://open.spotify.com/embed/episode/1q5rRq1ZdCu4FtEFgvNRDy?utm_source=generator'),
        Episode(
            title:
                'Michelle Char, una Reina que supo leer el contexto de la ciudad',
            embedUrl:
                'https://open.spotify.com/embed/episode/3oHc66jckUOuw3IGWNtKmq?utm_source=generator'),
        Episode(
            title:
                'KPOP 101 :: BTS y ARIRANG: un análisis entre tradición y modernidad',
            embedUrl:
                'https://open.spotify.com/embed/episode/0zILjVrg6Prbhxm1rjxwrZ?utm_source=generator'),
        Episode(
            title: 'Así Suena Colombia :: Pernett y su cumbia galáctica',
            embedUrl:
                'https://open.spotify.com/embed/episode/6wMREzU5hQPBfcyHRhy23a?utm_source=generator'),
        Episode(
            title:
                'Hey Prende La Luz :: ¡Energía para el futuro, energía para todos!',
            embedUrl:
                'https://open.spotify.com/embed/episode/4dML6t908dJy7bo3Op8vsD?utm_source=generator'),
        Episode(
            title:
                'Pensar en la era de la IA :: Cómo cultivar el juicio propio frente a la automatización del conocimiento',
            embedUrl:
                'https://open.spotify.com/embed/episode/4Z494BvefZu0gt9Rgl3hTX?utm_source=generator'),
        Episode(
            title: 'Encuéntrate :: Juicio literario. Víctor Frankenstein',
            embedUrl:
                'https://open.spotify.com/embed/episode/3ivnDFbge83cZwPooRf0qg?utm_source=generator'),
        Episode(
            title:
                'Todo es político :: Paz a la Página: Letras que Sanan. Entrevista a Lina Trigos',
            embedUrl:
                'https://open.spotify.com/embed/episode/1qxBg4AgTjQyiExJ0DlmuX?utm_source=generator'),
        Episode(
            title:
                'Los Egresados Hacen Noticia :: Emprendimiento de alto impacto, economía circular y el liderazgo del Caribe en la agenda climática global',
            embedUrl:
                'https://open.spotify.com/embed/episode/6cTtsgmffh35hgfcWzPNix?utm_source=generator'),
        Episode(
            title: 'Encuéntrate :: Sembrar antes de leer',
            embedUrl:
                'https://open.spotify.com/embed/episode/3btfV9bX4PBMsxQ4E5VEQo?utm_source=generator'),
        Episode(
            title:
                'Así Suena Colombia :: Un recorrido pista a pista por los Días de Cumbia de Cumbia Queen',
            embedUrl:
                'https://open.spotify.com/embed/episode/1sTWRSFmNGf7FESSicJFFF?utm_source=generator'),
        Episode(
            title:
                'Especial Día del Jazz :: El piano como puente entre la academia europea y el sabor barranquillero',
            embedUrl:
                'https://open.spotify.com/embed/episode/2UWT8MKwuC068KgB47lj9O?utm_source=generator'),
        Episode(
            title:
                'Alimentación Funcional y el poder de las frutas :: Entrevista a Coralia Osorio',
            embedUrl:
                'https://open.spotify.com/embed/episode/7xZ2BESEg4AVthrNiXlPcu?utm_source=generator'),
        Episode(
            title:
                'Ecodrones: La tecnología local que vigila la Ciénaga de Mallorquín',
            embedUrl:
                'https://open.spotify.com/embed/episode/16Yg1xvINcS11lJAnPYJl4?utm_source=generator'),
        Episode(
            title:
                'Hablemos de Negocios :: No siempre gana la empresa más ordenada',
            embedUrl:
                'https://open.spotify.com/embed/episode/2cRvDZIIMOV5OuktzC3XwS?utm_source=generator'),
        Episode(
            title:
                'Revivir una lengua :: El arte de traducir la memoria en Barrio Abajo',
            embedUrl:
                'https://open.spotify.com/embed/episode/59vandW9U2Buy4lZZXTYOw?utm_source=generator'),
        Episode(
            title:
                'Los Egresados Hacen Noticia :: Carlos Van-Strahlen, el estratega detrás de los "cracks" del fútbol mundial',
            embedUrl:
                'https://open.spotify.com/embed/episode/56PaeAspeOH6u87QlYLYVW?utm_source=generator'),
        Episode(
            title:
                '¿Barranquilla de moda? :: Entrevista a Toni Celia. Director Arte y Cultura Uninorte',
            embedUrl:
                'https://open.spotify.com/embed/episode/2VXC6niFXaTrPlhYgw4A04?utm_source=generator'),
        Episode(
            title: 'Mingo Sánchez y su propio territorio Gauta',
            embedUrl:
                'https://open.spotify.com/embed/episode/2Al0tnx6AGZmRkRlWom6nr?utm_source=generator'),
        Episode(
            title:
                'La ciencia detrás de por qué no puedes dejar de hacer scroll',
            embedUrl:
                'https://open.spotify.com/embed/episode/4flc5g1vray4tSDSsRRXsn?utm_source=generator'),
        Episode(
            title:
                'Crónica :: La Cumbia en buenas manos. La nueva generación de la Cumbia Moderna de Soledad',
            embedUrl:
                'https://open.spotify.com/embed/episode/7erSo7n6s27wg1ewWc7oJF?utm_source=generator'),
        Episode(
            title:
                'Todo es Político :: Reggaetón como fenómeno musical, cultural, social y político',
            embedUrl:
                'https://open.spotify.com/embed/episode/7E37MHpsRoX7WnonScfRh0?utm_source=generator'),
        Episode(
            title:
                'Amores modernos, relaciones no monogámicas y poliamor :: INVITADA: María Tambo',
            embedUrl:
                'https://open.spotify.com/embed/episode/2gq3PTDCULQfS2SJS716eN?utm_source=generator'),
        Episode(
            title:
                'Cápsulas de Salud :: Mitos, verdades y riesgos del diseño de sonrisa',
            embedUrl:
                'https://open.spotify.com/embed/episode/5r3a6f6N0tamJJNmT8KkCG?utm_source=generator'),
        Episode(
            title: 'La Pizarra :: La Felicidad también se enseña',
            embedUrl:
                'https://open.spotify.com/embed/episode/3H1n3d8WI7zjnCXAvaDxpM?utm_source=generator'),
        Episode(
            title:
                'Tinta Sonora :: BAQREADS, la comunidad de lectores en Barranquilla',
            embedUrl:
                'https://open.spotify.com/embed/episode/10bj02aE6AEpFMWNHjo0FR?utm_source=generator'),
        Episode(
            title:
                'Salud Mental :: ¿Puede una inteligencia artificial ser tu terapeuta?',
            embedUrl:
                'https://open.spotify.com/embed/episode/34vr2a2ocrMp8DHAW9SvyL?utm_source=generator'),
      ]),
  Show(
      id: 'asi-me-decidi',
      name: 'Así me decidí por... Uninorte',
      color: Color.fromARGB(255, 244, 6, 2),
      coverUrl: '',
      description: '',
      episodes: [
        Episode(
          title: 'Así me decidí por ... Ingeniería Mecánica',
          embedUrl:
              'https://open.spotify.com/embed/episode/1W4B9z7f88al2ghrzHEvYm?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Economía',
          embedUrl:
              'https://open.spotify.com/embed/episode/0Xt7D8EpOts84BBxNgV5xq?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Filosofía y Humanidades',
          embedUrl:
              'https://open.spotify.com/embed/episode/259gFgH13ePgoDYFiZdl2E?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Música',
          embedUrl:
              'https://open.spotify.com/embed/episode/5wFKezPTsf29xbjkA8QCHp?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Odontología',
          embedUrl:
              'https://open.spotify.com/embed/episode/5s5JB3yZfFG8gl2crse7YK?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Negocios Internacionales',
          embedUrl:
              'https://open.spotify.com/embed/episode/7naEgdVoHGjIDwdzm98C1n?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Geología',
          embedUrl:
              'https://open.spotify.com/embed/episode/5hZfuJkm0XSfHPieW5lpXA?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Ciencias Políticas',
          embedUrl:
              'https://open.spotify.com/embed/episode/61fpRwOsokcK5O1ThgBXvg?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Ingeniería Civíl',
          embedUrl:
              'https://open.spotify.com/embed/episode/4ewmf7who8kGsyzMmYbibc?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Diseño Gráfico',
          embedUrl:
              'https://open.spotify.com/embed/episode/2zTvXzzfK0Ppna2QIPOdw6?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Derecho',
          embedUrl:
              'https://open.spotify.com/embed/episode/1kfR7jVnK2g33cZnHiaDx6?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Relaciones Internacionales',
          embedUrl:
              'https://open.spotify.com/embed/episode/5WABavkbG2AgalROstgK9B?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Ciencia de Datos',
          embedUrl:
              'https://open.spotify.com/embed/episode/5S11FzWMOuUh5nWXk3puXh?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Matemáticas',
          embedUrl:
              'https://open.spotify.com/embed/episode/4n8WSkyxfzOTTpBhUthv7a?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Contaduría',
          embedUrl:
              'https://open.spotify.com/embed/episode/4QQ7h1jiOZaNZqMe5z4DOR?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Administración de Empresas',
          embedUrl:
              'https://open.spotify.com/embed/episode/02ugIBWAziWIWNuVBwFsFt?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Medicina',
          embedUrl:
              'https://open.spotify.com/embed/episode/1U4AZgIdyWITl5Wi4AtSXl?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Enfermería',
          embedUrl:
              'https://open.spotify.com/embed/episode/0VD1YsBK42arEo68jKDKLy?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Ingeniería Industrial',
          embedUrl:
              'https://open.spotify.com/embed/episode/382NqdOQ592hy8P2Kq4CZ4?utm_source=generator',
        ),
        Episode(
          title: 'Así me decidí por ... Ingeniería Eléctrica',
          embedUrl:
              'https://open.spotify.com/embed/episode/2x3S2oiB8MnF4OS38zbNEI?utm_source=generator',
        ),
      ]),
  Show(
      id: 'todos-cuentan',
      name: 'Todos Cuentan',
      color: Color(0xFFF59E0B),
      coverUrl: '',
      description:
          'Derecho, sociedad y ciudadanía desde una perspectiva accesible.',
      episodes: [
        Episode(
          title:
              'Todos Cuentan :: Empresa privada y protección de derechos humanos en zonas de conflicto armado',
          embedUrl:
              'https://open.spotify.com/embed/episode/6HYTHFcXLsfVj6YAlYmBzp?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: Migraciones y su marco normativo a nivel nacional e internacional',
          embedUrl:
              'https://open.spotify.com/embed/episode/1hakcxn7CVmhabQrb3MIgZ?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: Crueldad en el derecho y derecho a la crueldad. Diálogos interdisciplinarios',
          embedUrl:
              'https://open.spotify.com/embed/episode/0PATkxo7iKXCJmRoqzPDee?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: El impacto de los Criptoactivos en Colombia. INVITADO: Mario de la Puente',
          embedUrl:
              'https://open.spotify.com/embed/episode/1pJ42uGKougV15jeq5JEoP?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: 8vo Congreso Nacional de Ciencia Política - ACCPOL',
          embedUrl:
              'https://open.spotify.com/embed/episode/7xvUUEjEUGl9GG5x4e7f04?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: El Informe Final de la Comisión de la Verdad "Hay Futuro si Hay Verdad"',
          embedUrl:
              'https://open.spotify.com/embed/episode/4wPoOb81JsqMIU2BzlBnZM?utm_source=generator',
        ),
        Episode(
          title: 'Todos Cuentan :: Cooperación académica en Colombia',
          embedUrl:
              'https://open.spotify.com/embed/episode/63vsSaDPKqALHUXSc1nSLn?utm_source=generator',
        ),
        Episode(
          title:
              'Todos Cuentan :: La localización en el marco de la cooperación internacional',
          embedUrl:
              'https://open.spotify.com/embed/episode/53TOF0iWu0uQIbZwOAv0AH?utm_source=generator',
        ),
        Episode(
          title: 'Todos Cuentan :: La crisis de la integración regional',
          embedUrl:
              'https://open.spotify.com/embed/episode/1ZnCuMqKbt0SNwBquvnRRv?utm_source=generator',
        ),
        Episode(
          title: 'Todos Cuentan :: Resiliencia Territorial',
          embedUrl:
              'https://open.spotify.com/embed/episode/2lFBO7cmvlAfZvwcJjDbrH?utm_source=generator',
        ),
      ]),
  Show(
      id: 'historia-continua',
      name: 'La Historia Continúa',
      color: Color(0xFF8B5CF6),
      coverUrl: '',
      description:
          'Derecho, sociedad y ciudadanía desde una perspectiva accesible.',
      episodes: [
        Episode(
          title:
              'La Historia Continúa :: ¿Crisis del modelo liberal? Parte II. INVITADO: Héctor Galeano',
          embedUrl:
              'https://open.spotify.com/embed/episode/08gXLHhQOmfYwsxNMcZ6qx?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: ¿Crisis del modelo liberal? Parte I. INVITADO: Héctor Galeano',
          embedUrl:
              'https://open.spotify.com/embed/episode/3aoQeVxFom29ajW9o2WAAt?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Colombia, Región e Historia. Parte II',
          embedUrl:
              'https://open.spotify.com/embed/episode/4FmtD8Zq19AXsWOsoi83dl?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Colombia, Región e Historia. Parte I',
          embedUrl:
              'https://open.spotify.com/embed/episode/54WOo0XdE169AUeMdUA4BB?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Abolicionismo y fin del comercio de esclavos en el imperio español. Parte II',
          embedUrl:
              'https://open.spotify.com/embed/episode/2bIrYGVZ7ixb2SImP30YyT?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Abolicionismo y fin del comercio de esclavos en el imperio español. Parte I',
          embedUrl:
              'https://open.spotify.com/embed/episode/4HNzvkVhA4HNEhvOUADXAb?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Importancia geopolítica de los mares. Parte II',
          embedUrl:
              'https://open.spotify.com/embed/episode/3650ntG85yyRl0jRCDEQNi?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Importancia geopolítica de los mares. Parte I',
          embedUrl:
              'https://open.spotify.com/embed/episode/1eR6ciGtj4ULVDzeCaicUo?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: Los peligros de la diplomacia en redes sociales',
          embedUrl:
              'https://open.spotify.com/embed/episode/5ZDevDDYLDwEAgdMqzqg4R?utm_source=generator',
        ),
        Episode(
          title:
              'La Historia Continúa :: América Latina en la nueva era de Donald Trump. Parte II',
          embedUrl:
              'https://open.spotify.com/embed/episode/5U3cUuj3fBTBO3BtC0O3pV?utm_source=generator',
        ),
      ]),
  Show(
      id: 'salud',
      name: 'Salud Uninorte Radio',
      color: Color(0xFF10B981),
      coverUrl:
          'https://i.scdn.co/image/ab6765630000ba8a2d4e7f9c3b1a5e8d6c7b4a9f',
      description:
          'Salud, bienestar y ciencia médica explicados por expertos de Uninorte.',
      episodes: [
        Episode(
          title:
              'T1E23 :: Niños que Crecen en Movimiento: Cómo el Deporte Moldea su Futuro',
          embedUrl:
              'https://open.spotify.com/embed/episode/1BGOPU9XnQVfl80Nfe7sHu?utm_source=generator',
        ),
        Episode(
          title:
              'T1E22 : Cuando la procrastinación deja de ser hábito y se convierte en algo más profundo',
          embedUrl:
              'https://open.spotify.com/embed/episode/5G24kVTwFxajNp9sd4ViaL?utm_source=generator',
        ),
        Episode(
          title: 'T1E21: Lo que hemos aprendido',
          embedUrl:
              'https://open.spotify.com/embed/episode/45X2YKaUZajWMIhMgkI5U4?utm_source=generator',
        ),
        Episode(
          title:
              'T1E20: El estigma de la salud mental: mitos, lenguaje y transformación social con la Dra María C. García',
          embedUrl:
              'https://open.spotify.com/embed/episode/2UIsfm8J5bDhuwZJdJ4XwJ?utm_source=generator',
        ),
        Episode(
          title:
              'T1E19: Inteligencia Artificial y Salud Mental: ¿Aliada terapéutica o riesgo silencioso?',
          embedUrl:
              'https://open.spotify.com/embed/episode/1COAsJ7jc0hQS8H7uUsnJb?utm_source=generator',
        ),
        Episode(
          title:
              'T1E18: ¿Por qué no bajo de peso? Mitos y verdades Parte 2, con el Dr Ricardo Rosero',
          embedUrl:
              'https://open.spotify.com/embed/episode/7p5AzSYnZOZmqmfC7suQPT?utm_source=generator',
        ),
        Episode(
          title: 'T1E17 :: Capoeira: Arte, Deporte y Salud',
          embedUrl:
              'https://open.spotify.com/embed/episode/0rGEb7as6096zKkjlcE8tw?utm_source=generator',
        ),
        Episode(
          title:
              'T1E16 :: ¿Tienen derecho los niños y niñas diagnósticados con VIH/Sida a conocer su diagnóstico?',
          embedUrl:
              'https://open.spotify.com/embed/episode/6wiBkcXqmgawHkcxL2OEcg?utm_source=generator',
        ),
        Episode(
          title:
              'T1E15 :: Más allá de la medicina: la fotografía como un estilo de vida saludable',
          embedUrl:
              'https://open.spotify.com/embed/episode/6SwDxx7v4nQYoKN1nk3hRt?utm_source=generator',
        ),
        Episode(
          title:
              'T1E14 :: Medicina funcional e integrativa: mitos y realidades con la Dra Faride Ramos',
          embedUrl:
              'https://open.spotify.com/embed/episode/2xZD28ScgcEHDtiMtJoGVO?utm_source=generator',
        ),
        Episode(
          title: 'T1E13 :: Suicidio: mitos, señales de alerta y prevención',
          embedUrl:
              'https://open.spotify.com/embed/episode/1YEqzFNHZ1IRJUwIkXAfE6?utm_source=generator',
        ),
        Episode(
          title:
              'T1E12 :: Del estrés al burnout: cómo reconocerlo y prevenirlo',
          embedUrl:
              'https://open.spotify.com/embed/episode/3d9Jpz8sV62SGC0evUP01u?utm_source=generator',
        ),
        Episode(
          title:
              'T1E11 :: ¿Por qué no bajo de peso? Mitos y realidades con el Dr. Ricardo Rosero',
          embedUrl:
              'https://open.spotify.com/embed/episode/66sQPeYrjkFsrohP9vDldT?utm_source=generator',
        ),
        Episode(
          title:
              'T1E10 :: Cuando la pasión se convierte en innovación: pionera en cirugía ortopédica robótica',
          embedUrl:
              'https://open.spotify.com/embed/episode/0pyzbqgyhNKNNMZVEAWS5J?utm_source=generator',
        ),
        Episode(
          title: 'T1E9 :: Tiroides: mitos y verdades',
          embedUrl:
              'https://open.spotify.com/embed/episode/6HJFTXdqxEQF8iz1ibsbJy?utm_source=generator',
        ),
        Episode(
          title:
              'T1E8 :: Criar con conciencia: cómo alimentar el cuerpo y el futuro de nuestros niños',
          embedUrl:
              'https://open.spotify.com/embed/episode/2HBfNTwT80xjEbGZWbxlN8?utm_source=generator',
        ),
        Episode(
          title:
              'T1E7 :: Primeros auxilios psicológicos: cómo ayudar en una crisis emocional',
          embedUrl:
              'https://open.spotify.com/embed/episode/2DpWSLQJDLYq0UV60VQRcS?utm_source=generator',
        ),
        Episode(
          title:
              'T1E6 :: Fisioterapia, dolor crónico y obesidad: moverse para sanar',
          embedUrl:
              'https://open.spotify.com/embed/episode/4TnqOoBoQDyornEGfPEoGt?utm_source=generator',
        ),
        Episode(
          title:
              'T1E5 :: Comer bien para sanar: verdades y errores sobre la nutrición en la obesidad',
          embedUrl:
              'https://open.spotify.com/embed/episode/7N1pCsmsQWjv76moMFfOeG?utm_source=generator',
        ),
        Episode(
          title:
              'T1E4 :: Ejercicio seguro para el corazón: guía con un cardiólogo',
          embedUrl:
              'https://open.spotify.com/embed/episode/3N0UV7NMbr06g5IegTZCYj?utm_source=generator',
        ),
        Episode(
          title: 'T1E3 :: No puedo parar de comer, ¿será hambre emocional?',
          embedUrl:
              'https://open.spotify.com/embed/episode/3tCeZFK6LIXYh9jpS0Ogvj?utm_source=generator',
        ),
        Episode(
          title: 'T1E2: Cardio vs. Fuerza ¿Cuál ejercicio es mejor?',
          embedUrl:
              'https://open.spotify.com/embed/episode/5JijBAarotsXQx2APRXbRk?utm_source=generator',
        ),
        Episode(
          title:
              'T1E1. El inicio de un viaje: El primer capítulo de tu historia saludable',
          embedUrl:
              'https://open.spotify.com/embed/episode/1ZgHS8SQEUxmQsVOjbGfAQ?utm_source=generator',
        ),
      ]),
  Show(
    id: 'azul-celeste',
    name: 'Azul Celeste',
    color: Color(0xFF0EA5E9),
    coverUrl:
        'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
    description:
        'Poesía y literatura narrada, un viaje entre palabras y emociones.',
    episodes: [
      Episode(
        title: 'Azul Celeste :: A mano armada',
        embedUrl:
            'https://open.spotify.com/embed/episode/10ShA3xzvgQMgOp3sXgwAP?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Casa de Cuervos',
        embedUrl:
            'https://open.spotify.com/embed/episode/3bxLw2Hw8G551NCqLnhRUG?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Pienso que en este momento',
        embedUrl:
            'https://open.spotify.com/embed/episode/2wtjEFfYfPW3QGo8Lyytbk?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Con estrépito de música vengo',
        embedUrl:
            'https://open.spotify.com/embed/episode/1BbeS3WvG1wAXewxmGrHst?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: La Jaula',
        embedUrl:
            'https://open.spotify.com/embed/episode/6hPscIxqCBOJdArk58pE2f?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: La patria',
        embedUrl:
            'https://open.spotify.com/embed/episode/14JOErp4uPtRzJoq9L6Txj?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Donde habite el olvido',
        embedUrl:
            'https://open.spotify.com/embed/episode/4ujQDjL1Vwp4klLH4refJd?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: No entres dócilmente en esa buena noche',
        embedUrl:
            'https://open.spotify.com/embed/episode/6WX2JtzPru44kPBIPHWk6X?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Rabia',
        embedUrl:
            'https://open.spotify.com/embed/episode/1nH8Cv2goKPy957Qsoc0LF?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Estaciones',
        embedUrl:
            'https://open.spotify.com/embed/episode/53qL8sBk2RzXGe2mQV3zNv?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Terredad',
        embedUrl:
            'https://open.spotify.com/embed/episode/1hXb8AxVH9NtGGYREHyMEY?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Me sobra el corazón',
        embedUrl:
            'https://open.spotify.com/embed/episode/0XnACLbUcFk3zr027PGnpI?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: El anciano estoico',
        embedUrl:
            'https://open.spotify.com/embed/episode/5QM7qD2PaLwu2x14Me2aOe?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Abuela',
        embedUrl:
            'https://open.spotify.com/embed/episode/3kcDdZSXzoPbOxBBsyqlqM?utm_source=generator',
      ),
      Episode(
        title: 'Azul Celeste :: Oda al picaflor',
        embedUrl:
            'https://open.spotify.com/embed/episode/03Fm4pqzcZnInTMUYv4beM?utm_source=generator',
      ),
    ],
  ),
  Show(
      id: 'apocalipticos-integrados',
      name: 'Apocalípticos Integrados',
      color: Color(0xFF0EA5E9),
      coverUrl:
          'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
      description:
          'Poesía y literatura narrada, un viaje entre palabras y emociones.',
      episodes: [
        Episode(
          title:
              'Apocalípticos Integrados :: T1E14: Cultura en tránsito. Parte II',
          embedUrl:
              'https://open.spotify.com/embed/episode/2tXtSjPC8YWpvdCgOwJ9wK?utm_source=generator',
        ),
        Episode(
          title:
              'Apocalípticos Integrados :: T1E13: Cultura en tránsito. Parte I',
          embedUrl:
              'https://open.spotify.com/embed/episode/2ECkuOFB0BRzmf2dHYxpfM?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos Integrados :: T1E12: Máquinas de escribir',
          embedUrl:
              'https://open.spotify.com/embed/episode/0FTaKqjdVlJn525pWBZkml?utm_source=generator',
        ),
        Episode(
          title:
              'Apocalípticos Integrados :: T1E11: ¿Sigues ahí? Siguiente episodio en 5, 4, 3…',
          embedUrl:
              'https://open.spotify.com/embed/episode/3QaKoEL6TK6U1HVKyRLgq0?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos Integrados :: T1E10: Predicciones mediáticas',
          embedUrl:
              'https://open.spotify.com/embed/episode/6D2Km19BDi6m5lmuVsq0yY?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos Integrados :: T1E9: Historias que nos cuentan',
          embedUrl:
              'https://open.spotify.com/embed/episode/7FxUOl53bBSayz3tV2Mbvj?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos Integrados :: T1E8: La mente narrada',
          embedUrl:
              'https://open.spotify.com/embed/episode/4vfXysg9e1UYMJh3ZIUSSG?utm_source=generator',
        ),
        Episode(
          title:
              'Apocalípticos Integrados :: T1E7: Conversación en plano secuencia: Especial sobre “Adolescence”',
          embedUrl:
              'https://open.spotify.com/embed/episode/2lBDPkMIDRXltBAWBIaBs2?utm_source=generator',
        ),
        Episode(
          title:
              'Apocalípticos Integrados :: T1E6: Nostalgia y cultura reciclada',
          embedUrl:
              'https://open.spotify.com/embed/episode/4d9ZpvRmtYQLcRg16TLirZ?utm_source=generator',
        ),
        Episode(
          title:
              'Apocalípticos integrados :: T1E5: ¿El algoritmo decide por ti?',
          embedUrl:
              'https://open.spotify.com/embed/episode/707eWEvTAFYAnwt5epOoFq?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos integrados :: T1E4: Oscar time',
          embedUrl:
              'https://open.spotify.com/embed/episode/5Aexch6htVusLiU1SfKdLg?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos integrados :: T1E3: Al lado del camino',
          embedUrl:
              'https://open.spotify.com/embed/episode/3WvH1v90bSjJVpwwR6kyyy?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos integrados :: T1E2: ¿Cultura intermedia?',
          embedUrl:
              'https://open.spotify.com/embed/episode/3Z2901RFbC92ukfcdDTfNS?utm_source=generator',
        ),
        Episode(
          title: 'Apocalípticos integrados :: T1E1: Episodio piloto',
          embedUrl:
              'https://open.spotify.com/embed/episode/5f9QbcbqeWXKkkYYTurlCS?utm_source=generator',
        ),
      ]),
  Show(
    id: 'competividad-sostenible',
    name: 'Competitividad Sostenible',
    color: Color(0xFF0EA5E9),
    coverUrl:
        'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
    description:
        'Desarrollar ventajas a nivel empresarial que aseguren las necesidades del presente sin comprometer la capacidad de las generaciones futuras',
    episodes: [
      Episode(
        title:
            'Competitividad Sostenible :: El derecho aduanero como herramienta para la competitividad en el comercio internacional',
        embedUrl:
            'https://open.spotify.com/embed/episode/6AyWx5Ry1p95iYH8ZJ34nn?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad sostenible :: Aprendizajes desde los datos Latinoamericanos',
        embedUrl:
            'https://open.spotify.com/embed/episode/2T59VoFc4mBiZE7tBtqice?utm_source=generator',
      ),
      Episode(
        title: 'Competitividad Sostenible :: Maria Paz: Novo Nordisk Day',
        embedUrl:
            'https://open.spotify.com/embed/episode/3xpXToouUvCfjOZclfJJgo?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad Sostenible :: Reto de generaciones en el trabajo',
        embedUrl:
            'https://open.spotify.com/embed/episode/25f21uAzGHc2sqBzQMeHAn?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad Sostenible :: Transformación digital de la cadena de suministros. INVITADO: Andrés Castellanos',
        embedUrl:
            'https://open.spotify.com/embed/episode/6yc6fFd0dC9NGR8VSIrSwy?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad Sostenible :: Novo Nordisk Day. INVITADA: Patricia Field',
        embedUrl:
            'https://open.spotify.com/embed/episode/7rHZMrhpIDdKx2DGS1cTl6?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad Sostenible :: Entendiendo los modelos culturales, políticos y económicos de China',
        embedUrl:
            'https://open.spotify.com/embed/episode/5WiEAFReclFF7V7ifNXoop?utm_source=generator',
      ),
      Episode(
        title:
            'Competitividad Sostenible :: El día de la liberación económica de América: los aranceles recíprocos',
        embedUrl:
            'https://open.spotify.com/embed/episode/5TtCGQUkvXQ5PkNN8NXpuL?utm_source=generator',
      ),
      Episode(
        title: 'Primer Encuentro de Sostenibilidad del Caribe. Parte III',
        embedUrl:
            'https://open.spotify.com/embed/episode/6wqRMJhbw4ZF9GjU8uMIpT?utm_source=generator',
      ),
      Episode(
        title: 'Primer Encuentro de Sostenibilidad del Caribe. Parte II',
        embedUrl:
            'https://open.spotify.com/embed/episode/6YdDqc2wesI2QAES5zwx2C?utm_source=generator',
      ),
      Episode(
        title: 'Primer Encuentro de Sostenibilidad del Caribe. Parte I',
        embedUrl:
            'https://open.spotify.com/embed/episode/0LvgtkYajXtHULus3YWSyw?utm_source=generator',
      ),
      Episode(
        title:
            'Personas que Sostienen el Futuro: Talento Humano y Sostenibilidad Empresarial',
        embedUrl:
            'https://open.spotify.com/embed/episode/5HKth4ycvjFUxYja5a43WU?utm_source=generator',
      ),
      Episode(
        title:
            'EP. 16 - Turismo sostenible como camino para ser mas competitivos.',
        embedUrl:
            'https://open.spotify.com/embed/episode/14ppCL9WpdCbPL8f2RrGCH?utm_source=generator',
      ),
      Episode(
        title:
            'EP. 15 - Entre los Alpes y los Andes. La apuesta por el turismo en las montañas.',
        embedUrl:
            'https://open.spotify.com/embed/episode/3CLhdjhwEGXk2Qh31RbYkI?utm_source=generator',
      ),
      Episode(
        title: 'EP. 14 - El grupo Exito y su compromiso con la sostenibilidad',
        embedUrl:
            'https://open.spotify.com/embed/episode/4ibp6xk1teivkvPwKabLYr?utm_source=generator',
      ),
      Episode(
        title:
            'EP. 13 - Emprendimientos e internacionalización para fortalecer el ecosistema empresarial en Colombia',
        embedUrl:
            'https://open.spotify.com/embed/episode/6omW6IOKOOLNhRifJZHXzI?utm_source=generator',
      ),
      Episode(
        title:
            'EP. 12 - Mujeres y Negocios: deconstrucción de la brecha de genero en estudios de administración',
        embedUrl:
            'https://open.spotify.com/embed/episode/5d2wsjD4cbhL363ihryaCQ?utm_source=generator',
      ),
      Episode(
        title: 'Ep. 11 La sostenibilidad desde la visión del grupo Nutresa',
        embedUrl:
            'https://open.spotify.com/embed/episode/1dAeYmeX3Rafl3eG57fEHX?utm_source=generator',
      ),
      Episode(
        title: 'Ep. 10 - Innovación en Filnlandia',
        embedUrl:
            'https://open.spotify.com/embed/episode/4gfFKf3eN0GKhC1IAzBMY4?utm_source=generator',
      ),
      Episode(
        title: 'Ep. 9-Tecnología para Competitividad',
        embedUrl:
            'https://open.spotify.com/embed/episode/2pTco0Vk7KcqiqdC8XE9Fy?utm_source=generator',
      ),
    ],
  ),
  Show(
    id: 'emprende',
    name: 'Emprende +',
    color: Color(0xFF0EA5E9),
    coverUrl:
        'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
    description:
        'Poesía y literatura narrada, un viaje entre palabras y emociones.',
    episodes: [
      Episode(
        title:
            'Combinando formación con pasiones. Propiciando eventos. INVITADA: Daniela Bonett',
        embedUrl:
            'https://open.spotify.com/embed/episode/0hDezbzipzYFGo8qwTFDlJ?utm_source=generator',
      ),
      Episode(
        title: 'Finanzas con Sentido :: INVITADA: Marcela Berdugo',
        embedUrl:
            'https://open.spotify.com/embed/episode/5lEubjedtHpYvfyevH70hD?utm_source=generator',
      ),
      Episode(
        title: 'Resiliencia emprendedora :: INVITADO: Diovany Sánches',
        embedUrl:
            'https://open.spotify.com/embed/episode/0KheVXkFe06frtnXDhc0v7?utm_source=generator',
      ),
      Episode(
        title: 'Sabor y Negocios :: INVITADA: Patricia Maestre',
        embedUrl:
            'https://open.spotify.com/embed/episode/3X2ixDaLSrQQudPahTqsZo?utm_source=generator',
      ),
      Episode(
        title: 'Expansiones exitosas :: Especial Caribe Exponencial',
        embedUrl:
            'https://open.spotify.com/embed/episode/38wndwA3dbglRgZaeooxtj?utm_source=generator',
      ),
      Episode(
        title: 'Inversiones con Impacto en Latam',
        embedUrl:
            'https://open.spotify.com/embed/episode/2Qzmursa9b4l22CB8iLBjJ?utm_source=generator',
      ),
      Episode(
        title: 'Incubando Talento Emprendedor',
        embedUrl:
            'https://open.spotify.com/embed/episode/4xpTP0nPYLgJ9bLUnSx00v?utm_source=generator',
      ),
      Episode(
        title: 'Alianzas Exponenciales',
        embedUrl:
            'https://open.spotify.com/embed/episode/7fW8r59sN2fJhyUx4KCZs0?utm_source=generator',
      ),
      Episode(
        title:
            'Emprendimiento en tacones :: The Local Project + Viora Cosmetics',
        embedUrl:
            'https://open.spotify.com/embed/episode/5TUXN9oGowJikhbg0YjzDY?utm_source=generator',
      ),
    ],
  ),
  Show(
      id: 'intellecta',
      name: 'Intellecta',
      color: Color(0xFF0EA5E9),
      coverUrl:
          'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
      description:
          'Poesía y literatura narrada, un viaje entre palabras y emociones.',
      episodes: [
        Episode(
          title:
              'Combinando formación con pasiones. Propiciando eventos. INVITADA: Daniela Bonett',
          embedUrl:
              'https://open.spotify.com/embed/episode/0hDezbzipzYFGo8qwTFDlJ',
        ),
        Episode(
          title: 'Finanzas con Sentido :: INVITADA: Marcela Berdugo',
          embedUrl:
              'https://open.spotify.com/embed/episode/5lEubjedtHpYvfyevH70hD',
        ),
        Episode(
          title: 'Resiliencia emprendedora :: INVITADO: Diovany Sánches',
          embedUrl:
              'https://open.spotify.com/embed/episode/0KheVXkFe06frtnXDhc0v7',
        ),
        Episode(
          title: 'Sabor y Negocios :: INVITADA: Patricia Maestre',
          embedUrl:
              'https://open.spotify.com/embed/episode/3X2ixDaLSrQQudPahTqsZo',
        ),
        Episode(
          title: 'Expansiones exitosas :: Especial Caribe Exponencial',
          embedUrl:
              'https://open.spotify.com/embed/episode/38wndwA3dbglRgZaeooxtj',
        ),
        Episode(
          title: 'Inversiones con Impacto en Latam',
          embedUrl:
              'https://open.spotify.com/embed/episode/2Qzmursa9b4l22CB8iLBjJ',
        ),
        Episode(
          title: 'Incubando Talento Emprendedor',
          embedUrl:
              'https://open.spotify.com/embed/episode/4xpTP0nPYLgJ9bLUnSx00v',
        ),
        Episode(
          title: 'Alianzas Exponenciales',
          embedUrl:
              'https://open.spotify.com/embed/episode/7fW8r59sN2fJhyUx4KCZs0',
        ),
        Episode(
          title:
              'Emprendimiento en tacones :: The Local Project + Viora Cosmetics',
          embedUrl:
              'https://open.spotify.com/embed/episode/5TUXN9oGowJikhbg0YjzDY',
        ),
        Episode(
          title: 'Emprende +: Emprendimiento en Tacones',
          embedUrl:
              'https://open.spotify.com/embed/episode/5TUXN9oGowJikhbg0YjzDY',
        ),
      ]),
  Show(
    id: 'la-tercera-mision',
    name: 'La Tercera Misión',
    color: Color(0xFF0EA5E9),
    coverUrl:
        'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
    description:
        'Poesía y literatura narrada, un viaje entre palabras y emociones.',
    episodes: [
      Episode(
        title:
            'La Tercera Misión :: Comunicación para la transformación. Radio Cerrejón',
        embedUrl:
            'https://open.spotify.com/embed/episode/2fsmFYtMZxX8kB6sEp8ngj?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión :: Abriendo Puertas: Claves para una Cultura Inclusiva',
        embedUrl:
            'https://open.spotify.com/embed/episode/6hIvecbLnSgYVKDLj6Trs8?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión :: Arqueología preventiva para la responsabilidad empresarial, social y cultural',
        embedUrl:
            'https://open.spotify.com/embed/episode/4zYmDbqzm9Ex5okuH3VKLD?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión · Bienestar y liderazgo al interior de las Empresas',
        embedUrl:
            'https://open.spotify.com/embed/episode/0250Rq9jHmx4Kpwly2KeIW?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión · Educación para el cambio social. INVITADO: Jair Vega',
        embedUrl:
            'https://open.spotify.com/embed/episode/63G7XyBtZtpDje9KMgtPpf?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión · Articulando el tejido empresarial de la región. INVITADO: Mauricio Ortíz',
        embedUrl:
            'https://open.spotify.com/embed/episode/1a4rVZablzDQpUcD0pNjr7?utm_source=generator',
      ),
      Episode(
        title: 'La Tercera Misión · Salud Mental. INVITADO: Eduardo Verano',
        embedUrl:
            'https://open.spotify.com/embed/episode/0Yy0SG5CpDvM5Pteqaqu5s?utm_source=generator',
      ),
      Episode(
        title:
            'La Tercera Misión · Lactancia Materna y su promoción en el entorno laboral',
        embedUrl:
            'https://open.spotify.com/embed/episode/3G9je32PlhEOtM6IfIcZwb?utm_source=generator',
      ),
      Episode(
        title: 'La Tercera Misión · Empresas Emocionalmente Responsables',
        embedUrl:
            'https://open.spotify.com/embed/episode/5O64tlXaLn1xqDiG1eaBt8?utm_source=generator',
      ),
      Episode(
        title: 'La Tercera Misión · INVITADO: Pedro De La Torre',
        embedUrl:
            'https://open.spotify.com/embed/episode/0bTrG0kUKa6siSs1x48yow?utm_source=generator',
      ),
    ],
  ),
  /*
  Show(
    id: 'azul-celeste',
    name: 'Azul Celeste',
    color: Color(0xFF0EA5E9),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a6d1e0c27af93e6c6dc0f9a0a',
    description: 'Poesía y literatura narrada, un viaje entre palabras y emociones.',
    episodes: [
      Episode(title: 'Soneto 29', embedUrl: 'https://open.spotify.com/embed/episode/5mnkdwqeW5BDnSykDOn4KW?utm_source=generator'),
      Episode(title: 'Yo no quiero más luz que tu cuerpo frente al mío', embedUrl: 'https://open.spotify.com/embed/episode/0dOd5QLoaHuNZEbeTusP5S?utm_source=generator'),
      Episode(title: 'Yo me nazco', embedUrl: 'https://open.spotify.com/embed/episode/5ASvVQnFugCrMTvptdJ0lf?utm_source=generator'),
      Episode(title: 'Invictus', embedUrl: 'https://open.spotify.com/embed/episode/0dCgRbz2telMuWl4BufSaq?utm_source=generator'),
      Episode(title: 'Paren todos los relojes', embedUrl: 'https://open.spotify.com/embed/episode/26LLkEL1IKDyMR8iE6ZhuM?utm_source=generator'),
      Episode(title: '¿Qué tal si por ejemplo llega hasta mi un hombre...', embedUrl: 'https://open.spotify.com/embed/episode/0abyrowqdffs3dxNQaSfhv?utm_source=generator'),
      Episode(title: 'Lo que dejé por ti', embedUrl: 'https://open.spotify.com/embed/episode/0zR3q7rQ4Lmd5Nxf1sgwp9?utm_source=generator'),
      Episode(title: 'Mamá se fue', embedUrl: 'https://open.spotify.com/embed/episode/1Thad2VLXIqO7aKJgfXkUK?utm_source=generator'),
      Episode(title: 'Cubrir el cielo', embedUrl: 'https://open.spotify.com/embed/episode/00b5O98vtor1xx3o00Qep2?utm_source=generator'),
      Episode(title: 'Una fotografía antigua', embedUrl: 'https://open.spotify.com/embed/episode/6anBqDZTgLdFrq2dF6lNJ9?utm_source=generator'),
      Episode(title: 'A mano armada', embedUrl: 'https://open.spotify.com/embed/episode/10ShA3xzvgQMgOp3sXgwAP?utm_source=generator'),
      Episode(title: 'Casa de cuervos', embedUrl: 'https://open.spotify.com/embed/episode/3bxLw2Hw8G551NCqLnhRUG?utm_source=generator'),
      Episode(title: 'Pienso que en este momento', embedUrl: 'https://open.spotify.com/embed/episode/2wtjEFfYfPW3QGo8Lyytbk?utm_source=generator'),
      Episode(title: 'Con estrépito de música vengo', embedUrl: 'https://open.spotify.com/embed/episode/1BbeS3WvG1wAXewxmGrHst?utm_source=generator'),
      Episode(title: 'La jaula', embedUrl: 'https://open.spotify.com/embed/episode/6hPscIxqCBOJdArk58pE2f?utm_source=generator'),
      Episode(title: 'La patria', embedUrl: 'https://open.spotify.com/embed/episode/14JOErp4uPtRzJoq9L6Txj?utm_source=generator'),
    ],
  ),
  Show(
    id: 'historia-continua',
    name: 'La Historia Continúa',
    color: Color(0xFF8B5CF6),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a3c2e5a87e2f7f8e5b6c3e1d2',
    description: 'Análisis histórico y debates sobre los grandes temas de nuestra época.',
    episodes: [
      Episode(title: 'Justicia climática y medio ambiente. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/0Tkubgw6UTkRrU4mMfEkWb?utm_source=generator'),
      Episode(title: 'Justicia climática y medio ambiente. Parte I', embedUrl: 'https://open.spotify.com/embed/episode/2aECzlGmMv77qRWmuEszDr?utm_source=generator'),
      Episode(title: 'Paz en Centroamérica. Lecciones para Colombia', embedUrl: 'https://open.spotify.com/embed/episode/2tKxT9agLGs7EuUp2csKQJ?utm_source=generator'),
      Episode(title: 'Intervención de los EE.UU. en América Latina. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/2mZY9IfgaNn4zdrLu8WLKw?utm_source=generator'),
      Episode(title: 'Intervención de los EE.UU. en América Latina. Parte I', embedUrl: 'https://open.spotify.com/embed/episode/0jUy4zAQSy1xnb2ultnWU7?utm_source=generator'),
      Episode(title: 'Inteligencia Artificial, un reto para la sociedad actual', embedUrl: 'https://open.spotify.com/embed/episode/0qRF4wR1tMmtzcEzbPFJ0X?utm_source=generator'),
      Episode(title: 'Trabajo y Sociedad. Cartagena de Indias, 1750-1811. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/6l9Nz6lcdgYOzcDSuRqby4?utm_source=generator'),
      Episode(title: 'Trabajo y Sociedad. Cartagena de Indias, 1750-1811. Parte I', embedUrl: 'https://open.spotify.com/embed/episode/0I56vNp3cSGQpy2WtYfKZp?utm_source=generator'),
      Episode(title: 'Las bestias del llano como protagonistas de la independencia', embedUrl: 'https://open.spotify.com/embed/episode/12p8MXJ1ZZofKtNwQQSfLG?utm_source=generator'),
      Episode(title: '¿Crisis del modelo liberal? Parte II', embedUrl: 'https://open.spotify.com/embed/episode/08gXLHhQOmfYwsxNMcZ6qx?utm_source=generator'),
      Episode(title: '¿Crisis del modelo liberal? Parte I', embedUrl: 'https://open.spotify.com/embed/episode/3aoQeVxFom29ajW9o2WAAt?utm_source=generator'),
    ],
  ),
  Show(
    id: 'todos-cuentan',
    name: 'Todos Cuentan',
    color: Color(0xFFF59E0B),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8af4a2b5e8c1d9e7a6b5c4d3e2',
    description: 'Derecho, sociedad y ciudadanía desde una perspectiva accesible.',
    episodes: [
      Episode(title: 'La situación de los derechos humanos en Colombia', embedUrl: 'https://open.spotify.com/embed/episode/2tnQBuLoa4pObiVjRv8eMn?utm_source=generator'),
      Episode(title: 'El derecho de la competencia. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/74G4FUhp4LmSr1q5E4BlGM?utm_source=generator'),
      Episode(title: 'El derecho de la competencia. Parte I', embedUrl: 'https://open.spotify.com/embed/episode/6MJ2D7TVRWni8kDaEh4CbT?utm_source=generator'),
      Episode(title: '¿Qué podemos aprender hoy del Código Hammurabi?', embedUrl: 'https://open.spotify.com/embed/episode/6oa5hq0mnZrXrj1UC9kd0M?utm_source=generator'),
      Episode(title: 'Tiempos de fricción institucional. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/3XXmgQen2Ivc09f8bpvGz3?utm_source=generator'),
      Episode(title: 'Integración diferenciada y convergencia jurídica en Latinoamérica', embedUrl: 'https://open.spotify.com/embed/episode/740hYK5mMcFoXz8GgLhrEG?utm_source=generator'),
      Episode(title: 'El contrato más antiguo del mundo', embedUrl: 'https://open.spotify.com/embed/episode/0oJM1Q3VB94mWynl1u4D3n?utm_source=generator'),
      Episode(title: 'Tiempos de fricción institucional. Parte I', embedUrl: 'https://open.spotify.com/embed/episode/1xzaBKNudPS6R5jcrhAeju?utm_source=generator'),
      Episode(title: 'Sistema penal contra las mujeres en el delito de estupefacientes', embedUrl: 'https://open.spotify.com/embed/episode/0v8kQYbwS96SIqaJB3CWXa?utm_source=generator'),
      Episode(title: 'Linchamientos en América Latina. Parte II', embedUrl: 'https://open.spotify.com/embed/episode/3MQwiedtbjlMpP8n5TXhVp?utm_source=generator'),
    ],
  ),
  Show(
    id: 'salud',
    name: 'Salud Uninorte Radio',
    color: Color(0xFF10B981),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a2d4e7f9c3b1a5e8d6c7b4a9f',
    description: 'Salud, bienestar y ciencia médica explicados por expertos de Uninorte.',
    episodes: [
      Episode(title: 'Salud Uninorte Radio — EP 19', embedUrl: 'https://open.spotify.com/embed/episode/1COAsJ7jc0hQS8H7uUsnJb?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 18', embedUrl: 'https://open.spotify.com/embed/episode/7p5AzSYnZOZmqmfC7suQPT?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 17', embedUrl: 'https://open.spotify.com/embed/episode/0rGEb7as6096zKkjlcE8tw?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 16', embedUrl: 'https://open.spotify.com/embed/episode/6wiBkcXqmgawHkcxL2OEcg?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 15', embedUrl: 'https://open.spotify.com/embed/episode/6SwDxx7v4nQYoKN1nk3hRt?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 14', embedUrl: 'https://open.spotify.com/embed/episode/2xZD28ScgcEHDtiMtJoGVO?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 13', embedUrl: 'https://open.spotify.com/embed/episode/1YEqzFNHZ1IRJUwIkXAfE6?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 12', embedUrl: 'https://open.spotify.com/embed/episode/3d9Jpz8sV62SGC0evUP01u?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 11', embedUrl: 'https://open.spotify.com/embed/episode/66sQPeYrjkFsrohP9vDldT?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 10', embedUrl: 'https://open.spotify.com/embed/episode/0pyzbqgyhNKNNMZVEAWS5J?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 9',  embedUrl: 'https://open.spotify.com/embed/episode/6HJFTXdqxEQF8iz1ibsbJy?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 8',  embedUrl: 'https://open.spotify.com/embed/episode/2HBfNTwT80xjEbGZWbxlN8?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 7',  embedUrl: 'https://open.spotify.com/embed/episode/2DpWSLQJDLYq0UV60VQRcS?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 6',  embedUrl: 'https://open.spotify.com/embed/episode/4TnqOoBoQDyornEGfPEoGt?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 5',  embedUrl: 'https://open.spotify.com/embed/episode/7N1pCsmsQWjv76moMFfOeG?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 4',  embedUrl: 'https://open.spotify.com/embed/episode/3N0UV7NMbr06g5IegTZCYj?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 3',  embedUrl: 'https://open.spotify.com/embed/episode/3tCeZFK6LIXYh9jpS0Ogvj?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 2',  embedUrl: 'https://open.spotify.com/embed/episode/5JijBAarotsXQx2APRXbRk?utm_source=generator'),
      Episode(title: 'Salud Uninorte Radio — EP 1',  embedUrl: 'https://open.spotify.com/embed/episode/1ZgHS8SQEUxmQsVOjbGfAQ?utm_source=generator'),
    ],
  ),
  Show(
    id: 'asi-me-decidi',
    name: 'Así Me Decidí',
    color: Color(0xFFEC4899),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a8f3c2e1a7b5d4c6e9f2a1b0c',
    description: 'Estudiantes cuentan cómo eligieron su carrera en Uninorte.',
    episodes: [
      Episode(title: 'Ingeniería Mecánica', embedUrl: 'https://open.spotify.com/embed/episode/1W4B9z7f88al2ghrzHEvYm/video?utm_source=generator'),
      Episode(title: 'Economía', embedUrl: 'https://open.spotify.com/embed/episode/0Xt7D8EpOts84BBxNgV5xq/video?utm_source=generator'),
      Episode(title: 'Filosofía y Humanidades', embedUrl: 'https://open.spotify.com/embed/episode/259gFgH13ePgoDYFiZdl2E/video?utm_source=generator'),
      Episode(title: 'Música', embedUrl: 'https://open.spotify.com/embed/episode/5wFKezPTsf29xbjkA8QCHp/video?utm_source=generator'),
      Episode(title: 'Odontología', embedUrl: 'https://open.spotify.com/embed/episode/5s5JB3yZfFG8gl2crse7YK/video?utm_source=generator'),
      Episode(title: 'Negocios Internacionales', embedUrl: 'https://open.spotify.com/embed/episode/7naEgdVoHGjIDwdzm98C1n/video?utm_source=generator'),
    ],
  ),
  Show(
    id: 'dialogos-samario',
    name: 'Diálogos Samario',
    color: Color(0xFFD42020),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a1a3b5c7e9d2f4a6b8c0e1f3a',
    description: 'Conversaciones con líderes y personalidades del Caribe colombiano.',
    episodes: [
      Episode(title: 'Oriol Márquez, gerente del hotel Hilton', embedUrl: 'https://open.spotify.com/embed/episode/5XlOnhe6PVrsnaXdYvCTOC/video?utm_source=generator'),
      Episode(title: 'Patricia Apreza', embedUrl: 'https://open.spotify.com/embed/episode/1zf7LziKqFIugPHsBJysHc/video?utm_source=generator'),
      Episode(title: 'Carolina Torrado', embedUrl: 'https://open.spotify.com/embed/episode/7LZo10njmXoeiuswr6JJFJ/video?utm_source=generator'),
      Episode(title: 'Silvia Media', embedUrl: 'https://open.spotify.com/embed/episode/1P4P5lj1CrKnYTYJjfOTds/video?utm_source=generator'),
      Episode(title: 'Claudia Cuello', embedUrl: 'https://open.spotify.com/embed/episode/31TuRRGeKypmcDTUNjSlAD/video?utm_source=generator'),
      Episode(title: 'Mayorie Barón', embedUrl: 'https://open.spotify.com/embed/episode/1uRSz6t1tPk32OYLOb9szU/video?utm_source=generator'),
    ],
  ),
  Show(
    id: 'emprende',
    name: 'Emprende+',
    color: Color(0xFFF97316),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a5e7f2c4a9b3d1e6f8a0c2b4d',
    description: 'Innovación, emprendimiento social y economía circular en acción.',
    episodes: [
      Episode(title: 'Del prototipo al plato', embedUrl: 'https://open.spotify.com/embed/episode/5594R9plZ5kZ8DIt6yRomS?utm_source=generator'),
      Episode(title: 'Comunidad y bienes como motor emprendedor', embedUrl: 'https://open.spotify.com/embed/episode/001iMVTIECQnVnmBlTDKah?utm_source=generator'),
      Episode(title: 'Innovación disruptiva: Ideas que transforman mercados', embedUrl: 'https://open.spotify.com/embed/episode/1vCkgzVLlUQwy7OcXzoLAt?utm_source=generator'),
      Episode(title: 'El poder del Emprendimiento social', embedUrl: 'https://open.spotify.com/embed/episode/2Crf6xEA5h6xjPbzgk4Ztq?utm_source=generator'),
      Episode(title: 'Economía circular en acción', embedUrl: 'https://open.spotify.com/embed/episode/4rKh3vb4yciotCllbv5ihj?utm_source=generator'),
      Episode(title: 'Del reto a la estrategia', embedUrl: 'https://open.spotify.com/embed/episode/7hhyeVaDSHRjQOLttmpq5e?utm_source=generator'),
    ],
  ),
  Show(
    id: 'tardeando',
    name: 'Tardeando',
    color: Color(0xFF6366F1),
    coverUrl: 'https://i.scdn.co/image/ab6765630000ba8a9c1e3f5b7d2a4c6e8f0a1b2d',
    description: 'Cultura, ideas y conversaciones que hacen más interesante la tarde.',
    episodes: [
      Episode(title: 'Encuéntate Cátedra', embedUrl: 'https://open.spotify.com/embed/episode/6AjwT7PnZ1giXgC0FLxYWt?utm_source=generator'),
      Episode(title: 'HPL', embedUrl: 'https://open.spotify.com/embed/episode/45J9YnSutpPdrsLR9UUdTd?utm_source=generator'),
      Episode(title: 'Miguel Uribe', embedUrl: 'https://open.spotify.com/embed/episode/1vhG8c6Q9z46NtssjSzWVM?utm_source=generator'),
      Episode(title: 'Mochilón de la Sierra', embedUrl: 'https://open.spotify.com/embed/episode/4iBKl6tzTjTzAuzTsr4WWm?utm_source=generator'),
      Episode(title: 'La toga no tiene género, pero sí carácter', embedUrl: 'https://open.spotify.com/embed/episode/0y6jvsOLnBjEWSGqAqCxjR?utm_source=generator'),
      Episode(title: 'Ikigai Empresarial: alinear la misión empresarial', embedUrl: 'https://open.spotify.com/embed/episode/42mzlrK7qJFH1DK1Mj2Z2t?utm_source=generator'),
      Episode(title: 'Del sistema al diseño', embedUrl: 'https://open.spotify.com/embed/episode/6GgOZ9fAp7il3U94m1LXGt?utm_source=generator'),
      Episode(title: 'Arteria: Ecologías raciales en el río Magdalena', embedUrl: 'https://open.spotify.com/embed/episode/0hK0xv2YmOjjQMNeRqHJxc?utm_source=generator'),
      Episode(title: 'Brocha: La plataforma que acerca a artistas y públicos', embedUrl: 'https://open.spotify.com/embed/episode/6wzUIKq7Paa7BRfkMoavRe?utm_source=generator'),
      Episode(title: 'Libro Noche de Bala: un retrato del lado oscuro del Caribe', embedUrl: 'https://open.spotify.com/embed/episode/0z8xBOw29P0QIjCysIlBgp?utm_source=generator'),
      Episode(title: 'Encuéntate: Chrétien de Troyes y el Universo Artúrico', embedUrl: 'https://open.spotify.com/embed/episode/74IvN4pCiOkZr8eECm8Lna?utm_source=generator'),
      Episode(title: 'El reto de enseñar a pensar en la era de la IA', embedUrl: 'https://open.spotify.com/embed/episode/1DCopXpPn7B75S4tMhMX09?utm_source=generator'),
      Episode(title: 'Brasileirices: Del manglar al mundo, el sonido del Manguebeat', embedUrl: 'https://open.spotify.com/embed/episode/5PaiAtXclCm0AR1Qi3FPNf?utm_source=generator'),
    ],
  ),
  */
];
