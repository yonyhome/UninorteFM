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
];
