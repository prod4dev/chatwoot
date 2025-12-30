import { ref } from 'vue';

// Global shared state
const showAdvancedFeatures = ref(
  typeof document !== 'undefined'
    ? document.body.classList.contains('show-advanced-features')
    : false
);

// Set up observer once globally
if (typeof window !== 'undefined') {
  const checkAdvancedFeatures = () => {
    showAdvancedFeatures.value = document.body.classList.contains('show-advanced-features');
  };

  const observer = new MutationObserver(checkAdvancedFeatures);
  observer.observe(document.body, {
    attributes: true,
    attributeFilter: ['class'],
  });
}

export function useAdvancedFeatures() {
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
