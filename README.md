# ~ Wavy

[![Gem Version](https://badge.fury.io/rb/wavy.svg)](http://badge.fury.io/rb/wavy)

A simple templating engine for HTML – Inspired by [Sass](http://sass-lang.com).

## Usage

Install the gem

```
gem install wavy
```

#### Main

_main.wavy

```wavy
@import "mixins"
```

#### Mixins

_mixins.wavy

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

#### Template

view.html.wavy

```wavy
<div class="main">
  <div class="container">
  
    @include button({{label}}, gray)
    
  </div>
</div>
```

#### Compile

wavy <config> <template> <output_folder>

```
wavy main.wavy view.html.wavy ./
```

#### Output

view.html

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