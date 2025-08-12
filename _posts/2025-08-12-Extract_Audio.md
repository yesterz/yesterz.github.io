---
title: Python 脚本，提取视频的音频，并按同样的目录结构保存
date: 2025-08-12 15:32:00 +0800
author: 
categories: []
tags: []
pin: false
math: false
mermaid: false
---



Python 脚本，提取视频的音频，并按同样的目录结构保存

- `-i` 输入目录（递归搜索视频）
- `-o` 输出目录（保持相同的目录结构）
- 自动识别常见视频格式（如 `.mp4`, `.mkv`, `.mov` 等）
- 提取视频中的音频（保留原始音频编码，不转码，速度快）
- 如果需要可以改成转成统一格式（比如 `.mp3`）

代码如下：

```python
import os
import argparse
import subprocess
from pathlib import Path

# 支持的视频扩展名
VIDEO_EXTS = {".mp4", ".mkv", ".mov", ".avi", ".flv", ".wmv", ".webm"}

def extract_audio(input_path: Path, output_path: Path):
    """使用 ffmpeg 从视频提取音频"""
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # 如果想直接用原始音频编码（不转码）
    cmd = [
        "ffmpeg", "-i", str(input_path),
        "-vn",  # 不要视频流
        "-acodec", "copy",  # 保留原音频编码
        str(output_path)
    ]

    try:
        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"[OK] {input_path} -> {output_path}")
    except subprocess.CalledProcessError as e:
        print(f"[FAIL] {input_path}，错误：{e.stderr.decode(errors='ignore')}")

def main():
    parser = argparse.ArgumentParser(description="递归提取目录中所有视频的音频，保持目录结构")
    parser.add_argument("-i", "--input", required=True, help="输入视频目录")
    parser.add_argument("-o", "--output", required=True, help="输出音频目录")
    parser.add_argument("-f", "--format", default="m4a", help="输出音频格式（默认 m4a）")

    args = parser.parse_args()

    input_dir = Path(args.input).resolve()
    output_dir = Path(args.output).resolve()

    for video_path in input_dir.rglob("*"):
        if video_path.is_file() and video_path.suffix.lower() in VIDEO_EXTS:
            # 计算相对路径
            relative_path = video_path.relative_to(input_dir)
            # 输出路径：保持目录结构，只改后缀
            output_path = output_dir / relative_path.with_suffix(f".{args.format}")
            extract_audio(video_path, output_path)

if __name__ == "__main__":
    main()
```

### 使用示例

```bash
python extract_audio.py -i /path/to/videos -o /path/to/audios
```

- 默认输出 `.m4a` 格式（如果原视频是 AAC 编码，速度非常快）
- 想要转成 mp3：

```bash
python extract_audio.py -i /path/to/videos -o /path/to/audios -f mp3
```

### 注意

- 需要系统已安装 [ffmpeg](https://ffmpeg.org/download.html)
- 如果原视频音频编码和目标格式不匹配，`-acodec copy` 会失败，可以改成转码：

```python
"-acodec", "libmp3lame"  # 转成 mp3
```

------

