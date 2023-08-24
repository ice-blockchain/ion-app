const fs = require('fs');

function generateDartClassFromIcoMoonSelection(filePath) {
  const rawData = fs.readFileSync(filePath);
  const data = JSON.parse(rawData);
  const icons = data.icons;

  const iconEntries = icons.map(icon => {
    const name = icon.properties.name;
    const code = '0x' + icon.properties.code.toString(16);
    return `static const IconData ${name} = IconData(${code}, fontFamily: _kFontFam);`;
  });

  const classContent = `import 'package:flutter/material.dart';

class IcoMoonIcons {
    IcoMoonIcons._();

    static const String _kFontFam = 'IcoMoon';

    ${iconEntries.join('\n  ')}
}`;

  fs.writeFileSync('lib/icons/icomoon_icons.dart', classContent);
}

// Example usage:
generateDartClassFromIcoMoonSelection('assets/icons/icomoon_selection.json');