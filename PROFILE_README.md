# Página de Perfil do Usuário - Inspirada no Instagram

## 📱 Visão Geral

Esta implementação cria uma página de perfil completa inspirada no Instagram, usando apenas componentes nativos do Flutter sem dependências externas do pub.dev.

## 🎨 Características

### Layout Inspirado no Instagram
- **Header do Perfil**: Foto de perfil circular com borda amarela
- **Estatísticas**: Posts, Seguidores, Seguindo em formato compacto
- **Informações**: Nome de usuário, bio, verificação
- **Grid de Fotos**: Layout em grade 3x3 como o Instagram
- **Ações**: Botões de seguir/editar perfil e mensagem

### Funcionalidades Implementadas

#### 🔥 Firebase Integration
- Busca dados do usuário no Firestore
- Carrega posts do usuário
- Sistema de seguir/deixar de seguir
- Upload e gerenciamento de fotos de perfil

#### 📊 Gerenciamento de Estado
- **Cubit/BLoC**: Estados organizados para loading, sucesso, erro
- **Refresh**: Pull-to-refresh para atualizar dados
- **Loading States**: Indicadores visuais durante operações

#### 🎯 Componentes Customizados
- `ProfileImageWidget`: Foto de perfil com zoom e fallback
- `ProfileStatsWidget`: Estatísticas formatadas (K, M)
- `PostGridWidget`: Grid responsivo de posts

## 📂 Estrutura de Arquivos

```
lib/modules/profile/
├── pages/
│   ├── user_profile/
│   │   ├── cubit/
│   │   │   ├── user_profile_cubit.dart
│   │   │   └── user_profile_state.dart
│   │   └── user_profile_page.dart
│   └── profile_demo/
│       └── profile_demo_page.dart
├── providers/
│   ├── user_profile_provider.dart
│   └── user_profile_provider_firebase.dart
└── ...

lib/shared/
├── models/
│   ├── user_profile_model.dart
│   └── post_model.dart
└── components/profile/
    ├── profile_image_widget.dart
    ├── profile_stats_widget.dart
    └── post_grid_widget.dart
```

## 🚀 Como Usar

### 1. Navegação para o Perfil

```dart
// Navegar para o próprio perfil
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserProfilePage(userId: currentUserId),
  ),
);

// Navegar para perfil de outro usuário
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserProfilePage(userId: targetUserId),
  ),
);
```

### 2. Dependências Registradas

As dependências estão configuradas em `app_dependencies.dart`:

```dart
// Providers
injector.registerLazySingleton<UserProfileProvider>(
  () => UserProfileProviderFirebase(),
);

// Cubits
injector.registerLazySingleton(
  () => UserProfileCubit(
    userProfileProvider: injector.get<UserProfileProvider>(),
    accountInfoController: injector.get<AccountInfoController>(),
  ),
);
```

## 🎨 Design System

### Cores Utilizadas
- **Background**: `PhotoFlowColors.photoFlowBackground` (#121212)
- **Botão Principal**: `PhotoFlowColors.photoFlowButton` (#FFD600)
- **Texto Primário**: Branco (#FFFFFF)
- **Texto Secundário**: `PhotoFlowColors.photoFlowTextSecondary` (#B3B3B3)
- **Input Background**: `PhotoFlowColors.photoFlowInputBackground` (#333333)

### Tipografia
- **Nome do Usuário**: 16px, Bold, Branco
- **Bio**: 14px, Regular, Branco
- **Estatísticas**: 18px, Bold, Branco
- **Labels**: 14px, Regular, Cinza Secundário

## 🔧 Funcionalidades Avançadas

### 1. Sistema de Follow/Unfollow
```dart
// Seguir usuário
await cubit.toggleFollow(targetUserId);
```

### 2. Visualização de Imagem em Tela Cheia
- Toque na foto de perfil para zoom
- InteractiveViewer para pinch-to-zoom

### 3. Menu de Opções
- Compartilhar perfil
- Copiar link do perfil
- Modal bottom sheet nativo

### 4. Estados de Loading
- Loading inicial da página
- Loading durante follow/unfollow
- Loading de imagens com fallback

## 📱 Estados da Interface

### Loading State
```dart
const LoadingComponent() // Spinner customizado
```

### Error State
```dart
// Ícone de erro + mensagem + botão retry
Icon(Icons.error_outline)
Text('Erro ao carregar perfil')
ButtonComponent(title: 'Tentar Novamente')
```

### Empty State (Sem Posts)
```dart
// Ícone de câmera + mensagem motivacional
Icon(Icons.camera_alt_outlined)
Text('Nenhuma foto ainda')
Text('Compartilhe suas primeiras fotos!')
```

## 🔄 Refresh e Atualizações

### Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () => cubit.refreshProfile(userId),
  child: SingleChildScrollView(...),
)
```

### Auto-Refresh após Ações
- Após seguir/deixar de seguir
- Após upload de nova foto
- Após edição de perfil

## 🎯 Próximos Passos

Para expandir a funcionalidade:

1. **Edição de Perfil**: Tela para editar nome, bio e foto
2. **Visualização de Posts**: Tela detalhada do post com comentários
3. **Lista de Seguidores/Seguindo**: Telas com listas de usuários
4. **Mensagens**: Sistema de chat direto
5. **Stories**: Implementação de stories temporários
6. **Busca de Usuários**: Sistema de descoberta

## 🏗️ Arquitetura

### Clean Architecture
- **Presentation**: Pages, Cubits, Widgets
- **Domain**: Models, Abstract Providers
- **Data**: Firebase Providers, External APIs

### Injeção de Dependência
- GetIt para gerenciamento de dependências
- Providers registrados como singletons
- Cubits com ciclo de vida controlado

Esta implementação fornece uma base sólida para um sistema de perfil completo, seguindo boas práticas de desenvolvimento Flutter e mantendo a experiência do usuário similar ao Instagram.
