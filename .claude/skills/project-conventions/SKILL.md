---
name: project-conventions
description: Enforces project-specific conventions for this codebase. Use when writing code, creating files, or making architectural decisions specific to this project.
allowed-tools: Read, Glob, Grep
---

# Project-Specific Conventions

## Quick Reference

This Skill enforces conventions specific to this project. Always check `CLAUDE.md` for the most up-to-date standards.

### File Structure

- Components: `src/components/`
- Screens: `src/screens/` or `app/`
- Hooks: `src/hooks/`
- Services: `src/services/`
- Utils: `src/utils/`
- Types: `src/types/`

### Import Order

```typescript
// 1. External imports
import React from 'react';
import { View, Text } from 'react-native';

// 2. Internal absolute imports
import { Button } from '@/components';
import { useAuth } from '@/hooks';

// 3. Relative imports
import { localHelper } from './helpers';

// 4. Types
import type { User } from '@/types';
```

### Component Template

```typescript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface ComponentNameProps {
  // Props definition
}

export const ComponentName: React.FC<ComponentNameProps> = ({ }) => {
  // Component logic

  return (
    <View style={styles.container}>
      {/* JSX */}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    // Styles
  },
});
```

## See Also

- Full standards: `CLAUDE.md`
- Architecture: `docs/ARCHITECTURE.md`
