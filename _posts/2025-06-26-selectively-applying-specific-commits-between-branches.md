要将 `uat` 分支上的两个提交合并到 `feature-xfeatxxx` 分支，你可以按照以下步骤操作：

> **cherry-pick**
>
> [verb] choose and take only (the most beneficial or profitable items, opportunities, etc.) from what is available;

## cherry-pick

1. **切换到目标分支**：

   ```
   git checkout feature-xfeatxxx
   ```

2. **找到要合并的提交**：

   - 使用 `git log uat` 查看 `uat` 分支的提交历史，找到你要合并的两个提交的哈希值（如 `abc123` 和 `def456`）。

3. **合并提交**：

   ```
   git cherry-pick abc123 def456
   ```

   - 这会将这些提交应用到 `feature-xfeatxxx` 分支。

4. **解决冲突（如果有）**：

   * 使用Visual Studio Code或者IDEA打开冲突文件来解决冲突；

   - 如果出现冲突，手动解决后运行：

     ```
     git add .
     git cherry-pick --continue
     ```

5. **推送更改**：

   ```
   git push origin feature-xfeatxxx
   ```

### 注意事项：

- 如果这两个提交不是连续的，`cherry-pick` 是最灵活的方式。

- 确保在操作前先拉取最新代码：

  ```
  git pull origin feature-xfeatxxx
  git pull origin uat
  ```


## References

1. [Git - git-cherry-pick Documentation;](https://git-scm.com/docs/git-cherry-pick)