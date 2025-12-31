<script setup lang="ts">
import { ref } from "vue";
import { useToast } from "vue-toastification";

const props = defineProps<{
  email: string;
  deactivateAccount: () =>  void;
  deleteAccount: () => void;
}>();

const emit = defineEmits<{
  (e: "close"): void;
}>();

const toast = useToast();

const isChecked = ref(false);


const handleDelete = () => {
  if (!isChecked.value) {
    toast.warning("Please check the box before deleting your account.");
    return;
  }

  // Checkbox is checked, call the delete function
  props.deleteAccount();
};

</script>

<template>
  <div class="fixed top-0 left-0 h-screen w-full bg-black/70 z-20">
    <div
      class="lg:w-[30%] sm:w-[448px] w-4/5 fixed top-[50%] left-[50%] -translate-y-[50%] -translate-x-[50%] sm:p-[16px] p-8 bg-white border border-[#DBDBDB] rounded-[8px] flex flex-col gap-[18px]"
    >
      <svg
        width="18"
        height="18"
        viewBox="0 0 18 18"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="grid place-self-end cursor-pointer"
        @click="emit('close')"
      >
        <path
          d="M4.5 13.5L13.5 4.5M4.5 4.5L13.5 13.5"
          stroke="#32363E"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>

      <div v-if="props.email" class="flex flex-col gap-[18px]">
        <h2 className="text-center font-bold text-[24px]">Delete Account</h2>

        <p class="text-[#525866] text-[18px] text-center">
          Are you sure you want to delete the account linked to
          <span class="font-bold">{{ props.email }}</span
          >?
        </p>

        <div class="flex flex-row items-start gap-[12px]">
          <div class="size-[20px] translate-y-1">
            <input v-model="isChecked" type="checkbox" class="w-full h-full" />
          </div>
          <p class="text-[#525866] text-[18px]">
            I understand that i won't be able to recover my account.
          </p>
        </div>

        <div class="flex flex-row items-center justify-center gap-[22px]">
          <button
            class="bg-[#FF6875] w-[160px] h-[48px] rounded-[11.62px] text-[13.55px] font-medium text-white"
            @click="handleDelete"
          >
            Delete
          </button>
          <button
            class="bg-[#F5F7FA] w-[160px] h-[48px] rounded-[11.62px] text-[13.55px] font-medium text-[#0E121B]"
            @click="emit('close')"
          >
            Cancel
          </button>
        </div>
      </div>
      <div v-else class="flex flex-col gap-[18px]">
        <h2 className="text-center font-bold text-[24px]">
          Deactivate Account
        </h2>

        <p class="text-[#525866] text-center text-[16px]">
          Are you sure you want to deactivate your account? You can reactivate
          anytime by logging in
        </p>

        <div class="flex flex-row items-center justify-center gap-[22px]">
          <button
            class="bg-[#FF6875] w-[160px] h-[48px] rounded-[11.62px] text-[13.55px] font-medium text-white"
            @click="props.deactivateAccount"
          >
            Deactivate
          </button>
          <button
            class="bg-[#F5F7FA] w-[160px] h-[48px] rounded-[11.62px] text-[13.55px] font-medium text-[#0E121B]"
            @click="emit('close')"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
