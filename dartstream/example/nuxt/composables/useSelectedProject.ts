// composables/useSelectedProject.ts
export const useSelectedProject = () => {
  const key = 'selectedProject';
  const state = useState<string | null>('selectedProjectState', () => {
    if (process.client) return localStorage.getItem(key);
    return null;
  });

  const setSelectedProject = (id: string | number | null) => {
    const v = id === null ? null : String(id);
    state.value = v;
    if (!process.client) return;
    if (v === null) localStorage.removeItem(key);
    else localStorage.setItem(key, v);
  };

  return { selectedProjectId: state, setSelectedProject };
};
