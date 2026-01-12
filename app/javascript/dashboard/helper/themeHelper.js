import { LocalStorage } from 'shared/helpers/localStorage';
import { LOCAL_STORAGE_KEYS } from 'dashboard/constants/localStorage';

export const setColorTheme = isOSOnDarkMode => {
  const selectedColorScheme =
    LocalStorage.get(LOCAL_STORAGE_KEYS.COLOR_SCHEME) || 'light';
  if (
    (selectedColorScheme === 'auto' && isOSOnDarkMode) ||
    selectedColorScheme === 'dark'
  ) {
    document.body.classList.add('dark');
    document.documentElement.style.setProperty('color-scheme', 'dark');
  } else {
    document.body.classList.remove('dark');
    document.documentElement.style.setProperty('color-scheme', 'light');
  }
};

// Global function for console access
if (typeof window !== 'undefined') {
  window.setTheme = theme => {
    if (!['light', 'dark', 'auto'].includes(theme)) {
      console.error('❌ Theme must be one of: light, dark, auto');
      return;
    }
    LocalStorage.set(LOCAL_STORAGE_KEYS.COLOR_SCHEME, theme);
    const isOSOnDarkMode = window.matchMedia(
      '(prefers-color-scheme: dark)'
    ).matches;
    setColorTheme(isOSOnDarkMode);
    console.log(`🎨 Theme changed to: ${theme}`);
  };
}
