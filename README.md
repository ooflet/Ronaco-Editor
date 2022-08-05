# Ronaco-Editor
IDE with autocomplete, lua parser, lua sandboxing, inbuilt syntax error detection + syntax fixer &amp; live syntax highlighting

Loadstring: `loadstring`

---

### Documentation

To create and embed the editor call `_G.Ronaco:EmbedEditor(parent)`  
Ronaco will automatically size itself to the parent frame. 

Run sandbox: `_G.Ronaco:RunInSandbox()`  
Stop sandbox: `_G.Ronaco:StopSandbox()`  
Save script: `_G.Ronaco:Save()`

---

### K-Ronaco

Kommand uses a special version of Ronaco which allows the terminal to modify Ronaco. Most functions bear the same name as their Lua counterpart

Run sandbox: `runsandbox`  
Stop sandbox: `stopsandbox`  
Save script: `save`  

---

### MIT LICENCE

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
