if ("undefined" == typeof(BackupTabs)) { //verifica se existe a// funcao
  var BackupTabs = {};
};

BackupTabs.BrowserOverlay = { //funcao pai
  saveTabsTxt:function(aEvent) { //funcao filha
    Components.utils.import("resource://gre/modules/osfile.jsm"); //importa classes da base da mozilla
    let sessionstore = OS.Path.join(OS.Constants.Path.profileDir, "sessionstore.js");
    let decoder = new TextDecoder();
    let promise = OS.File.read(sessionstore);
    promise = promise.then(
      function onSuccess(array) {
        let conteudo = decoder.decode(array);        // Converte array para texto string
        let filtro1 = conteudo.split('{"url":"');
        let lista = '';
        let re = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
        for(x=1;x<=filtro1.length/2;x++){
          let filtro = filtro1[x].split('",');
          if(filtro[0].match(re)){
              if(filtro[0].length > 500){
                let cut = filtro[0].split('#');
                lista = lista+cut[0]+"\n";
              } else{
                lista = lista+filtro[0]+"\n";
              }
          }
        }
        let promise2 = OS.File.writeAtomic("BackupTabs.txt", lista,
          {tmpPath: "file.txt.tmp"});
        let string = document.getElementById("backuptabs-string-bundle");
        let mensagem = string.getString("backuptabs.greeting.label");
        window.alert(mensagem);
      }
    );
  }
};
