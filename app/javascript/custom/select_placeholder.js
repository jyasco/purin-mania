document.addEventListener('turbo:load', function() {
  const selects = document.querySelectorAll('select.select-bordered');
  
  selects.forEach(select => {
    const placeholder = select.querySelector('option[value=""]');
    
    // 初期状態の色を設定
    updateSelectColor(select);

    select.addEventListener('change', function() {
      updateSelectColor(this);
    });

    // フォーカス時の処理
    select.addEventListener('focus', function() {
      if (this.value === '' && !this.classList.contains('select-keep-blank')) {
        placeholder.hidden = true;
      }
    });

    // フォーカスが外れた時の処理
    select.addEventListener('blur', function() {
      if (this.value === '') {
        placeholder.hidden = false;
        this.style.color = '#C5B6A8'; // placeholderの色
      }
    });
  });

  // 色を更新する関数
  function updateSelectColor(select) {
    if (select.value) {
      select.style.color = '#2C1803'; // 通常のテキスト色
    } else {
      select.style.color = '#C5B6A8'; // placeholderの色
    }
  }
});