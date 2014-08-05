# ~ Wavy

A simple templating engine for HTML – Inspired by [Sass](http://sass-lang.com).

## Usage

_main.wavy

```wavy
@mixin button($label, $class) {
  <div class="button {$class}">
    @include v-align({$label})
  </div>
}

@mixin v-align($content) {
  <div class="v-align">
    {$content}
  </div>
}
```

view.html.wavy

```wavy
<div class="main">
  <div class="container">
  
    @include button({{label}}, gray)
    
  </div>
</div>
```

Outputs: view.html

```html
<div class="main">
  <div class="container">
  
    <div class="button gray">
      <div class="v-align">
        {{label}}
      </div>
    </div>
    
  </div>
</div>
```

## Authors

[Matthew Govaere](http://matthewgovaere.com) (@matthewgovaere) created Wavy out 
  of the need for a simple method to reuse chunks of code for HTML templates.