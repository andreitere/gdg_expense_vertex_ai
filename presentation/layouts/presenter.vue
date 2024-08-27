<template>
  <div class="slidev-layout relative">
    <div class="flex items-center h-full">
      <div class="w-2/3">
        <slot></slot>
      </div>
      <figure v-if="$attrs.presenterImage" class="w-1/3 relative">
        <img :src="$attrs.presenterImage"
          class="bg-gray-400 relative important-rounded-2xl object-cover w-70 max-h-70 object-fit border border-6 border-black z-10" />
      </figure>
    </div>
    <LayoutFooter v-bind="$attrs" />
  </div>
</template>
