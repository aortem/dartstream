// plugins/vue-toastification.client.ts
import Toast, { type PluginOptions, POSITION, TYPE } from 'vue-toastification';
// Import the CSS file (or create your own theme)
import 'vue-toastification/dist/index.css';

export default defineNuxtPlugin(nuxtApp => {
  // Default plugin options
  const options: PluginOptions = {
    position: POSITION.TOP_RIGHT, // Default position
    timeout: 3000,                // Default timeout in milliseconds (3 seconds)
    closeOnClick: true,
    pauseOnFocusLoss: true,
    pauseOnHover: true,
    draggable: true,
    draggablePercent: 0.6,
    showCloseButtonOnHover: false,
    hideProgressBar: false,
    closeButton: "button",        // Type of close button ("button", "svg", false)
    icon: true,                   // Show default icon
    rtl: false,                   // Right to left layout
    transition: "Vue-Toastification__bounce", // Default transition
    maxToasts: 20,                // Max number of toasts at once
    newestOnTop: true,            // Show newest toast on top

    // You can provide default options for specific toast types globally
    // For example, to make all error toasts last longer by default:
    // toastClassName: "my-custom-toast", // Custom class for all toasts
    // defaultToastProps: { // This seems not to be a direct option, rather use per-type options on call
    //   [TYPE.ERROR]: { timeout: 5000 },
    //   [TYPE.SUCCESS]: { hideProgressBar: true }
    // }
    // It's generally easier to override options per call, see Step 4.
  };

  nuxtApp.vueApp.use(Toast, options);
});