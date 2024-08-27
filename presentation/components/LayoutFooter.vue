<script setup lang="ts">
import { computed } from 'vue'
import { useNow } from '@vueuse/core'

defineProps({
  eventLogo: {
    type: String,
  },
  eventUrl: {
    type: String,
  },
  x: {
    type: String,
  },
  xUrl: {
    type: String,
  },
  hideFooter: {
    type: Boolean
  }
})

const { now } = useNow()

const date = computed(() => now?.value.toLocaleDateString('en-US'))
</script>

<template>
  <footer v-if="!$frontmatter.hideFooter"
    class="absolute bottom-0 p-4 mt-auto flex items-center w-full text-primary dark:text-white z-10">
    <div class="mb-0 flex items-center text-xs">
      <a :href="$slidev.themeConfigs.eventUrl" target="_blank" class="mr-4">
        <logos-google-developers mr-1 /> Google Developer Groups
      </a>
      <a v-if="$slidev.themeConfigs.x" :href="$slidev.themeConfigs.xUrl" target="_blank">
        <line-md-twitter-x /> {{ $slidev.themeConfigs.x }}</a>
    </div>
  </footer>
</template>

<style scoped>
a {
  border-color: transparent;
}
</style>
