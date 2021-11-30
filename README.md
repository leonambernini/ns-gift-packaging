# ns-gift-packaging
Recurso extra para possibilitar o cliente adicionar uma embalagem ao pedido, podendo customizar os textos e cores para ampliar as possibilidades de "embalagens":

Para a utilização deste recurso o lojista precisa realizar o cadastro de um "produto" para ser utilizado como "embalagem" este produto pode ser gratuito ou com valor, recomendamos o cadastro com NOME e FOTO adequado a embalagem para ficar bem-apresentado e claro para o cliente final a apresentação no carrinho e checkout.

Ex: Embalagem para presente, Embalagem especial, Embalagem discreta, etc.

# Configurações e personalização no painel

- **Habilitar opção de embalagem no carrinho?**
Campo responsável por ativar/desativar o recurso no carrinho de compras
- **ID do produto utilizado como embalagem**
Campo de texto onde é informado o ID do produto que será utilizado como embalagem, este produto por ser com ou sem valor. Para identificar o ID do produto basta acessar o Pinel → Produtos, encontre o produto desejado e clique para editar, na página de edição do produto copie o código da URL: ex. https://leonambernini.lojavirtualnuvem.com.br/admin/products/**105254804**/ onde **105254804** é o ID do produto.
- **Mensagem para seleção da embalagem no carrinho**
Mensagem utilizada como titulo no box de aplicação da embalagem no carrinho.
- **Mensagem do botão para adicionar a embalagem**
Mensagem do botão para aplicar a embalagem ao carrinho.
- **Cores**
Opções de cores para personalizar todo o box com as cores da marca/loja 

# Instalação via tema base

Para instalar no tema base da Nuvem Shop basta clonar este repositório e substituir os arquivos do tema
Tema utilizado como referencia [TiendaNube/base-theme](https://github.com/TiendaNube/base-theme).




# Instalação manual

O código deve ser instalado via FTP atualizando alguns dos arquivos .tpl padrões da Nuvem Shop.

- 1. config/settings.txt
- 2. static/css/style-colors.scss.tpl
- 3. static/js/store.js.tpl
- 4. snipplets/cart-item-ajax.tpl
- 5. snipplets/cart-totals.tpl

Além das alterações é necessário criar um arquivo na pasta **snipplets** chamado **gift-packaging.tpl**

- 6. snipplets/gift-packaging.tpl


## 1. config/settings.txt

Abra o arquivo settings.txt busque pela sessão `Encabezado` ou `Cabeçalho`
Antes da sessão `Encabezado` adicione o seguinte código:

```twig
Embalagem personalizada
	meta
		icon = gift
		advanced = true
	checkbox
		name = lb_gift_packaging
		description = Habilitar opção de embalagem no carrinho?
	i18n_input
		name = lb_gift_packaging_product
		description = ID do produto utilizado como embalagem

	title
		title = Personalização
	subtitle
		subtitle = Textos
	i18n_input
		name = lb_gift_packaging_msg
		description = Mensagem para seleção da embalagem no carrinho
	i18n_input
		name = lb_gift_packaging_msg_cta
		description = Mensagem do botão para adicionar a embalagem
	subtitle
		subtitle = Cores
	color
		name = lb_gift_packaging_box_bg
		description = Cor de fundo da caixa de Mensagem
	color
		name = lb_gift_packaging_title_color
		description = Cor do titulo
	color
		name = lb_gift_packaging_cta_bg
		description = Cor de fundo do botão
	color
		name = lb_gift_packaging_cta_text
		description = Cor do texto do botão
```

## 2. static/css/style-colors.scss.tpl

Este arquivo é responsável pela customização das cores, então busque por `#Components` e logo no início da sessão inclua o seguinte código:

```twig
{# /* // Gift Packaging - Leonam Bernini */ #}

.js-lb-gift-packaging-options{
  padding: 15px;
  box-shadow: 0 2px 10px 0 rgba(0,0,0,.14);
  border-radius: 5px;
  {% if settings.lb_gift_packaging_box_bg != '' %}
    background: {{ settings.lb_gift_packaging_box_bg }};
  {% else %}
    background: transparent;
  {% endif %}
  p{
    {% if settings.lb_gift_packaging_title_color != '' %}
      color: {{ settings.lb_gift_packaging_title_color }};
    {% else %}
      color: $primary-color;
    {% endif %}
  }
  .btn{
    {% if settings.lb_gift_packaging_cta_bg != '' %}
      background: {{ settings.lb_gift_packaging_cta_bg }};
    {% else %}
      background: transparent;
    {% endif %}
    {% if settings.lb_gift_packaging_cta_text != '' %}
      color: {{ settings.lb_gift_packaging_cta_text }};
    {% else %}
      color: $primary-color;
    {% endif %}
    transition: 300ms all;
    &:hover{
      {% if settings.lb_gift_packaging_cta_bg != '' %}
        background: darken({{ settings.lb_gift_packaging_cta_bg }}, 10%);
      {% endif %}
    }
  }
}
```

## 3. static/js/store.js.tpl

No arquivo store.js.tpl iremos inserir o script que irá fazer o controle dos produtos "embalagem" no carrinho. Busque por `$(document).ready(function(){` que é responsável por aguardar o carregamento da página, e adicione o seguinte código logo após.

```twig
{# /* // Gift Packaging - Leonam Bernini */ #}
{% if settings.lb_gift_packaging and settings.lb_gift_packaging_product != '' %}
    function ajustGiftPackagingActions(){
        var $gift_packaging_cart_item = $('.js-cart-item[data-store="cart-item-{{ settings.lb_gift_packaging_product }}"]');
        if( $('.js-lb-gift-packaging-options').length ){
            if( $gift_packaging_cart_item.length || !$('.js-cart-item').length ){
                $('.js-lb-gift-packaging-options').fadeOut();
            }else{
                $('.js-lb-gift-packaging-options').fadeIn();
            }
        }
    }

    $(document).on('click', '.js-lb-gift-packaging-add', function(){
        var $this = $(this);
        var ctaText = $this.html();
        var $box = $this.closest('.js-lb-gift-packaging-options');
        var product_id = $box.data('product');

        var $formData = $(
            '<form method="post" action="/comprar/">'+
            '   <input type="hidden" name="add_to_cart" value="'+product_id+'">'+
            '   <input type="number" name="quantity" value="1">'+
            '</form>'
        );
        LS.addToCartEnhanced(
            $formData,
            ctaText,
            '',
            '',
            true,
            function(){ ajustGiftPackagingActions()},
            function(){ ajustGiftPackagingActions() },
        );
        return false;
    });

    $(document).on('DOMNodeInserted DOMNodeRemoved', '.js-ajax-cart-list', function() {
        setTimeout( function(){
            ajustGiftPackagingActions();
        }, 500);
    });
    setTimeout( function(){
        ajustGiftPackagingActions();
    }, 1000);
{% endif %}
```


## 4. snipplets/cart-item-ajax.tpl

Agora vamos inserir uma validação no arquivo **cart-item-ajax.tpl** para esconder a opção de alterar a quantidade do produto "embalagem".

Na primeira linha do arquivo adicione o seguinte código:

```twig
{% set is_gift_item = item.product.id == settings.lb_gift_packaging_product %}
```

Este código cria uma variável para informar se o produto adicionado ao carrinho é uma "embalagem".

Tendo esta variável criada, devemos encontrar a linha responsável pelo código da quantidade, geralmente uma `div` com a **class** `cart-item-quantity`.

Adicione `style="{% if is_gift_item %}display: none;{% endif %}"` no elemento, ficando assim:
```twig
<div class="cart-item-quantity {% if cart_page %}col-7 col-md-3 text-center{% endif %}" style="{% if is_gift_item %}display: none;{% endif %}">
```

## 5. snipplets/cart-totals.tpl

O último arquivo a ser alterado **cart-totals.tpl**, é o arquivo onde iremos incluir a chamada para um novo TPL (**gift-packaging.tpl**) responsável por adicionar o box de inclusão da "embalagem" ao carrinho.

Dentro de **cart-totals.tpl** adicione o seguinte código na primeira linha do arquivo.

```twig
{# Gift Packaging - Leonam Bernini #}
{% include "snipplets/gift-packaging.tpl" %}
```

E para que tudo funcione corretamente, crie um arquivo na pasta **snipplets** chamado **gift-packaging.tpl** com o seguinte código.

```twig
{# Product Gift Packaging - Leonam Bernini #}
{% if settings.lb_gift_packaging and settings.lb_gift_packaging_product != '' %}

    {% set gift_packaging_msg = settings.lb_gift_packaging_msg | default('Deseja incluir uma embalagem para presente?') %}
    {% set gift_packaging_msg_cta = settings.lb_gift_packaging_msg_cta | default('Sim, adicionar embalagem') %}
    <div class="js-lb-gift-packaging-options cart-row mb-4 text-center" style="display: none;" data-product="{{ settings.lb_gift_packaging_product }}">
        <p class="h5">{{ gift_packaging_msg }}</p>
        <button class="js-lb-gift-packaging-add btn btn-secondary btn-small w-100">{{ gift_packaging_msg_cta }}</button>
    </div>

{% endif %}
```

**OBS: O código pode variar de um layout para outro, encontre sempre o melhor lugar para inserir os scripts.**

