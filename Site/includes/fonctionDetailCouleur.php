<?php
function obtenirCouleurCSS($couleurBD) {
    $couleurs = [
        'Noir' => '#000000',
        'Blanc' => '#E4E4CB',
        'Rouge' => '#FF0000',
        'Orange' => '#FFA500',
        'Rose' => '#FFC0CB',
        'Jaune' => '#FFFF00',
        'Sable' => '#F4A460',
        'Bleu' => '#0000FF',
        'Bleu-ciel' => '#87CEEB',
        'Cyan' => '#00FFFF',
        'Turquoise' => '#40E0D0',
        'Bleu-marine' => '#000080',
        'Vert' => '#008000',
        'Vert-clair' => '#90EE90',
        'Kaki' => '#F0E68C',
        'Olive' => '#808000',
        'Violet' => '#800080',
        'Magenta' => '#FF00FF',
        'Bordeaux' => '#800000',
        'Gris' => '#808080',
        'Gris-clair' => '#D3D3D3',
        'Gris-Anthracite' => '#2F4F4F',
        'Marron' => '#A52A2A',
        'Beige' => '#F5F5DC',
        'Argent' => '#C0C0C0',
        'Doré' => '#FFD700',
    ];

    return isset($couleurs[$couleurBD]) ? $couleurs[$couleurBD] : null;
}
?>