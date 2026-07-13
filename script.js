const fs = require('fs');
const files = [
  'c:\\Users\\dines\\Desktop\\rk industry\\index.html',
  'c:\\Users\\dines\\Desktop\\rk industry\\rk industry\\index.html'
];

files.forEach(file => {
  if (fs.existsSync(file)) {
    let content = fs.readFileSync(file, 'utf8');
    
    if (!content.includes('.prod-btn.coming-soon')) {
      const css = "\n        .prod-btn.coming-soon {\n            background: rgba(255, 255, 255, 0.05);\n            color: #94a3b8;\n            border: 1px dashed #64748b;\n            pointer-events: none;\n            box-shadow: none;\n        }\n</style>";
      content = content.replace('</style>', css);
    }
    
    for (let i = 2; i <= 6; i++) {
        const regexOnclick = new RegExp(`onclick="location\\\\.href='product\\\\.html\\\\?id=${i}'"`, 'g');
        content = content.replace(regexOnclick, 'style="cursor: default;"');
    }
    
    const regexCard = /style="cursor: default;"([\s\S]*?)<button class="prod-btn">View Details<\/button>/g;
    content = content.replace(regexCard, 'style="cursor: default;"<button class="prod-btn coming-soon">Coming Soon</button>');

    fs.writeFileSync(file, content, 'utf8');
  }
});
console.log('Done');
