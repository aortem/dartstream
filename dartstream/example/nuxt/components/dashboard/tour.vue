<script setup lang="ts">
import { onMounted } from "vue";
import { useToast } from "vue-toastification";

const { $api, $shepherd } = useNuxtApp();
const toast = useToast();

const authUser = JSON.parse(localStorage.getItem("auth_user") || "{}");
const userId = authUser?.uid;
const tourKey = `${userId}_onboarding`;

const startTour = () => {
  const Shepherd = $shepherd as typeof import("shepherd.js");
  const tour = new Shepherd.Tour({
    useModalOverlay: true,
    defaultStepOptions: {
      cancelIcon: { enabled: false },
      scrollTo: { behavior: "smooth", block: "center" },
    },
  });

  const bindStepControls = (bind: (root: HTMLElement) => void) => {
    setTimeout(() => {
      const step = tour.getCurrentStep();
      const root = step?.getElement() as HTMLElement | null;
      if (root) bind(root);
    }, 0);
  };

  // 🔹 Helper for exit (mark tour completed)
  const handleExit = async () => {
    try {
      await $api(`/v1/users/${userId}/product-tours/${tourKey}`, {
        method: "PUT",
        body: {
          completed: true,
          completed_at: new Date().toISOString(),
        },
      });

      toast.success("Tour status updated");
    } catch (err) {
      toast.error("Failed to update Tour status");
      console.error("Failed to update tour completion:", err);
    } finally {
      tour.cancel();
    }
  };

  // 🧩 Add your tour steps here (same as before)
  tour.addStep({
    id: "welcome",
    text: `
      <div class="w-[637px] h-[318px] bg-white rounded-lg border border-[#DBDBDB] p-[24px]">
        <div class="flex justify-between items-center mb-[36px]">
          <div><img src="/images/logo.png" /></div>
          <div data-exit class="cursor-pointer">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
              <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
        </div>
        <div class="text-center text-[24px] font-bold mb-[18px]">Welcome to Intellitoggle</div>
        <div class="text-center text-[18px] text-[#4B4B4F] mb-[24px]">
          This quick tour will help you understand the essentials — from your dashboard to advanced tools like Experiments and Audit Logs.
        </div>
        <button data-start class="w-full bg-[#42489E] text-white py-3 rounded-[10px] mb-3 hover:bg-[#42489E] transition">Start Tour</button>
      </div>
    `,
    buttons: [],
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-start]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelector<HTMLElement>("[data-exit]")
            ?.addEventListener("click", handleExit, { once: true });
        });
      },
    },
  });

  // ... other steps ...
  tour.addStep({
    id: "cards",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Dashboard Overview</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      This is your Dashboard. It gives you a high-level snapshot: total flags, total users, environments, and what’s currently live in production. Think of it as your command center.
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>
`,
    attachTo: { element: ".dashboard-cards", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "sidebar",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Sidebar Navigation</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      Use the sidebar to move around. Here you’ll find core sections like Feature Flags, Experiments, Audit Logs, and Settings. We’ll start with Flags — your most powerful tool.
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-sidebar", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "feature-flag",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Feature Flags</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      This is your Feature Flags hub. From here, you can view, edit, and organize all your flags in one place
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-feature-flag", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "create-flag",
    classes: "create-flag-css",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px] relative right-[48px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Create Flag</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      Click here to create your first feature flag. Flags let you enable or disable features instantly—without redeploying code.
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-create-flag", on: "left" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "experiment",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Experiments</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      Experiments let you test features, run A/B tests, and validate ideas with real data. Perfect for data-driven decisions
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-experiment", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "audits",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Audit Logs</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      Every action is tracked here. Audit Logs keep your workflow transparent — great for collaboration, compliance, and accountability
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-audits", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.addStep({
    id: "settings",
    classes: "",
    text: `
<div class="w-[448px] h-[315px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.4)] backdrop-blur-[33.77px] p-[16px]">
  <div class="w-full h-full inline-flex flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[18px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">Settings</div>
    <div class="text-[18px] leading-[27px] text-[#000] text-center mb-[18px]">
      Settings let you manage your team, environments, and integrations. Customize IntelliToggle to match your exact needs
    </div>
    <div class="flex justify-between gap-4">
      <button data-back class="flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-white">Back</button>
      <button data-next class="text-white flex w-40 h-12 px-3 justify-center items-center gap-1 rounded-lg border border-[#335CFF] bg-[#42489E] transition">Next</button>
    </div>
  </div>
</div>`,
    attachTo: { element: ".dashboard-settings", on: "right" },
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelector<HTMLElement>("[data-back]")
            ?.addEventListener("click", () => tour.back(), { once: true });
          root
            .querySelector<HTMLElement>("[data-next]")
            ?.addEventListener("click", () => tour.next(), { once: true });
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  // ✅ Last step marks tour complete
  tour.addStep({
    id: "complete",
    text: `
      <div
  class="w-[637px] h-[318px] rounded-lg border border-[#DBDBDB] bg-white shadow-[0_4px_40px_10px_rgba(66,72,158,0.5)] backdrop-blur-[33.77071762084961px] p-[24px]">
  <div class="w-full h-full inline-flex p-6 flex-col justify-center items-center">
    <div class="flex justify-between items-center self-stretch mb-[10px]">
      <div></div>
      <div class="cursor-pointer">
        <svg data-exit xmlns="http://www.w3.org/2000/svg" width="18" height="19" viewBox="0 0 18 19" fill="none">
          <path d="M4.5 13.792L13.5 4.79199M4.5 4.79199L13.5 13.792" stroke="#32363E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="text-center text-[24px] font-[700] mb-[18px] capitalize">You’re Ready to Go!</div>
    <div class="text-[20px] leading-[27px] text-[#4B4B4F] text-center mb-[18px]">
      That’s the tour! You’re all set to create your first flag and start shipping features with confidence.
    </div>
    <button data-exit
      class="w-full bg-[#42489E] text-white py-3 rounded-[10px] mb-3 hover:bg-[#42489E] transition">
      Explore Dashboard
    </button>
  </div>
</div>

    `,
    when: {
      show: () => {
        bindStepControls((root) => {
          root
            .querySelectorAll<HTMLElement>("[data-exit]")
            .forEach((el) =>
              el.addEventListener("click", handleExit, { once: true })
            );
        });
      },
    },
    buttons: [],
  });

  tour.start();
};

onMounted(async () => {
  try {
    // Check tour status from backend
    const res = await $api(`/v1/users/${userId}/product-tours/${tourKey}`);
    const { completed } = res;
    console.log("Complete:", completed);

    // Only show tour if not completed
    if (!completed) startTour();
  } catch (err) {
    console.error("Error checking tour status:", err);
  }
});
</script>

<!-- Added template to stop Vue waring in console -->
<!-- [Vue warn]: Component is missing template or render function:
{ __name: 'DashboardTour', ... } -->
<template>
  <div class="hidden"></div>
</template>
