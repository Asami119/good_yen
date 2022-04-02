function good_yen (){
  const radioButton = document.getElementById('radio_button')
  radioButton.addEventListener('change', () => {
    const html = document.getElementById('id_balloon')
    if (html == null) {
      const insertPoint = document.getElementById('insert_point');
      const messages = ['Good yen!', 'Good yen!', 'Good yen!', 'ありがとう！', 'いいね！', 'ステキ！', 'さすがです！', '最高！'];
      const messageNo = Math.floor(Math.random() * messages.length);
      const html = `
        <div id="id_balloon">
          <p class="balloon">${messages[messageNo]}</p>
        </div>`;
      insertPoint.insertAdjacentHTML('afterend', html);
    } else {
        html.remove();    
      };
  });
};

window.addEventListener('load', good_yen);
