document.addEventListener('DOMContentLoaded', function() {
  setupImageUpload();
});

document.addEventListener('turbo:load', function() {
  setupImageUpload();
});

function setupImageUpload() {
  const container = document.getElementById('image-upload-container');
  const addImageBtn = document.getElementById('add-image-btn');
  
  if (container && addImageBtn) {
    let imageCount = container.querySelectorAll('.relative').length;

    function updateAddButtonVisibility() {
      addImageBtn.style.display = imageCount >= 3 ? 'none' : 'block';
    }

    updateAddButtonVisibility();

    addImageBtn.addEventListener('click', function() {
      if (imageCount < 3) {
        const newField = createNewImageField(imageCount);
        container.insertBefore(newField, addImageBtn.parentNode);
        imageCount++;
        updateAddButtonVisibility();
        setupImagePreview(newField.querySelector('input[type="file"]'));
      }
    });

    // 既存のファイル入力フィールドにイベントリスナーを設定
    document.querySelectorAll('#image-upload-container input[type="file"].image-upload').forEach(setupImagePreview);

    // MutationObserverを使用して動的に追加されたフィールドを監視
    const observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        if (mutation.type === 'childList') {
          mutation.addedNodes.forEach(function(node) {
            if (node.nodeType === Node.ELEMENT_NODE && node.matches('.relative')) {
              const newFileInput = node.querySelector('input[type="file"].image-upload');
              if (newFileInput) {
                setupImagePreview(newFileInput);
              }
            }
          });
        }
      });
    });

    observer.observe(container, { childList: true, subtree: true });
  }
}

function createNewImageField(index) {
  const newField = document.createElement('div');
  newField.className = 'mb-2 relative';
  const fieldId = Date.now();
  newField.innerHTML = `
    <label for="post_post_images_attributes_${fieldId}_image" class="file-input-label flex cursor-pointer">
      <span class="flex-none px-4 py-2 rounded-l bg-main text-white">ファイルを選択</span>
      <span class="flex-grow px-4 py-2 rounded-r bg-white text-placeholder truncate" data-file-name>ファイルが選択されていません</span>
    </label>
    <input class="hidden image-upload" accept="image/*" type="file" name="post[post_images_attributes][${index}][image]" id="post_post_images_attributes_${fieldId}_image">
  `;
  return newField;
}

function setupImagePreview(fileInput) {
  fileInput.addEventListener('change', function(e) {
    const file = e.target.files[0];
    const fileNameSpan = e.target.closest('.relative').querySelector('[data-file-name]');
    if (file) {
      fileNameSpan.textContent = file.name;
      const reader = new FileReader();
      reader.onload = function(e) {
        const previewContainer = fileInput.closest('.relative');
        let existingPreview = previewContainer.querySelector('img');
        if (existingPreview) {
          existingPreview.src = e.target.result;
        } else {
          existingPreview = document.createElement('img');
          existingPreview.src = e.target.result;
          existingPreview.className = "mt-2 w-24 h-24 object-cover rounded";
          previewContainer.appendChild(existingPreview);
        }
      }
      reader.readAsDataURL(file);
    } else {
      fileNameSpan.textContent = 'ファイルが選択されていません';
    }
  });
}