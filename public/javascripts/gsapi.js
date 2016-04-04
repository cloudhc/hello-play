/**
 * Lists the entries from the specified JSON feed
 * by inserting the cells into a new 'table' 
 * element in the DOM.  Each 'tr' represents a 
 * row in the spreadsheet, and each 'td' is a cell
 * within that row.
 */
function cellEntries(json) { 
  removeOldResults();

  var table = document.createElement('table');
  table.setAttribute('id', 'output');
  table.setAttribute('class', 'table table-striped');
  var tbody = document.createElement('tbody');

  var tr = null;
  
  for (var i=0; i < json.feed.entry.length; i++) {
    var entry = json.feed.entry[i];
    
    // skip column 1
    if (entry.gs$cell.col == '1')
      continue;
      
    if (entry.gs$cell.col == '2') {
      if (tr != null) {
        tbody.appendChild(tr);
      }

      tr = document.createElement('tr');
    }

    var td = document.createElement('td');
    td.setAttribute('style', "font-size:10px;");
    td.appendChild(document.createTextNode(entry.content.$t));
    tr.appendChild(td);
  } 
 
  tbody.appendChild(tr);
  table.appendChild(tbody);
  document.getElementById('data').appendChild(table);
}

/**
 * Removes the script element from the previous result.
 */
function removeOldJSONScriptNodes() {
  var jsonScript = document.getElementById('jsonScript');
  if (jsonScript) {
    jsonScript.parentNode.removeChild(jsonScript);
  }
}

/**
 * Removes the output generated from the previous result.
 */
function removeOldResults() {
  var div = document.getElementById('data');
  if (div.firstChild) {
    div.removeChild(div.firstChild);
  }
}

function change(){
  removeOldJSONScriptNodes();
  removeOldResults();

  // Show a "Loading..." indicator.
  var div = document.getElementById('data');
  var p = document.createElement('p');
  p.appendChild(document.createTextNode('Loading...'));
  div.appendChild(p);
  
  // Retrieve the JSON feed.
  var script = document.createElement('script');


  script.setAttribute('src', 'https://spreadsheets.google.com/feeds/cells'
              + '/1n3uci3ucTqJOA1nIDO90ihfPPJkpM6JQRSdwZdLN6aQ'
              + '/5/public/values'
              + '?alt=json-in-script&callback=cellEntries');
                        
  script.setAttribute('id', 'jsonScript');
  script.setAttribute('type', 'text/javascript');
  document.documentElement.firstChild.appendChild(script);
}