function good_yen (){
  const goodYenLabel = document.getElementById('good_yen_label');
  const notGoodYenLabel = document.getElementById('not_good_yen_label');

  goodYenLabel.addEventListener('click', () => {
    const insertPoint = document.getElementById('insert_point');
    const messages = ['Good yen!', 'Good yen!', 'Good yen!', 'ありがとう！', 'いいね！', 'ステキ！', 'さすがです！', '最高！'];
    const messageNo = Math.floor(Math.random() * messages.length);
    const html = `
      <div id="id_balloon">
        <p class="balloon">${messages[messageNo]}</p>
      </div>`;
    insertPoint.insertAdjacentHTML('afterend', html);
  });

  notGoodYenLabel.addEventListener('click', () => {
    const html = document.getElementById('id_balloon')
    html.remove();
  });
};

window.addEventListener('load', good_yen);
