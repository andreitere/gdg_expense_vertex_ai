<template>
  <div class="slidev-layout intro grid relative">
    <div class="absolute inset-0 bg-black opacity-80 z-1"></div>
    <div class="flex flex-col justify-center text-center text-white z-2">
      <slot></slot>
    </div>
    <LayoutFooter />
  </div>
</template>

<style>
.slidev-layout.intro {
  background: url(/from_paper_to_json_dark.png);
  background-size: cover;

  h1 {
    @apply text-6xl leading-20 font-display font-extrabold text-white;
  }

  h1+p {
    @apply opacity-60 -mt-4 text-2xl;
  }

  a {
    @apply text-secondary-400 hover:text-secondary-500 dark:(text-white hover:text-gray-200);
  }
}
</style>
