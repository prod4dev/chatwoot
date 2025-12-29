import { ref, onMounted, onUnmounted } from 'vue';

export function useAdvancedFeatures() {
  const showAdvancedFeatures = ref(false);

  const checkAdvancedFeatures = () => {
    showAdvancedFeatures.value = document.body.classList.contains('show-advanced-features');
  };

  onMounted(() => {
    checkAdvancedFeatures();

    // Watch for class changes on body
    const observer = new MutationObserver(checkAdvancedFeatures);
    observer.observe(document.body, {
      attributes: true,
      attributeFilter: ['class'],
    });

    // Store observer for cleanup
    window._advancedFeaturesObserver = observer;
  });

  onUnmounted(() => {
    if (window._advancedFeaturesObserver) {
      window._advancedFeaturesObserver.disconnect();
    }
  });

  return {
    showAdvancedFeatures,
  };
}

// Global toggle function for console access
if (typeof window !== 'undefined') {
  window.toggleAdvancedFeatures = () => {
    document.body.classList.toggle('show-advanced-features');
    const isEnabled = document.body.classList.contains('show-advanced-features');
    console.log(`🔧 Advanced features ${isEnabled ? '✅ enabled' : '❌ disabled'}`);
    return isEnabled;
  };

  // Show helper message on load (only once)
  if (!window._advancedFeaturesMessageShown) {
    window._advancedFeaturesMessageShown = true;
    console.log(
      '%c💡 P4D Fork - Advanced Features',
      'font-weight: bold; font-size: 14px; color: #3b82f6;',
      '\nPara activar features avanzadas (Capitán, Contactos, Informes, etc.), ejecutá:\n  toggleAdvancedFeatures()\n'
    );
  }
}
