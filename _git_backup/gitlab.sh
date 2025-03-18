#!/bin/bash

# 设置变量
ACCESS_TOKEN="glpat-Y-b4FSsqxsdze-xD5Ljy"  # 替换为您的个人访问令牌
GITLAB_API="https://gitlab.com/api/v4"    # 根据需要修改为自托管 GitLab 的 API URL
BACKUP_DIR="$HOME/gitlab_backup"          # 备份的目标目录

# 创建备份目录并进入
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR" || { echo "无法进入备份目录"; exit 1; }

# 函数：获取所有组
get_all_groups() {
    local page=1
    local per_page=100
    local groups=()

    while : ; do
        response=$(curl --silent --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "$GITLAB_API/groups?membership=true&per_page=$per_page&page=$page")
        
        # 检查是否有返回结果
        count=$(echo "$response" | jq '. | length')
        if [ "$count" -eq "0" ]; then
            break
        fi

        groups+=($(echo "$response" | jq -r '.[] | {id: .id, name: .full_path} | @base64'))
        page=$((page + 1))
    done

    echo "${groups[@]}"
}

# 函数：获取某个组的所有项目
get_projects_of_group() {
    local group_id="$1"
    local page=1
    local per_page=100
    local projects=()

    while : ; do
        response=$(curl --silent --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "$GITLAB_API/groups/$group_id/projects?per_page=$per_page&page=$page")
        
        # 检查是否有返回结果
        count=$(echo "$response" | jq '. | length')
        if [ "$count" -eq "0" ]; then
            break
        fi

        projects+=($(echo "$response" | jq -r '.[] | .ssh_url_to_repo'))
        page=$((page + 1))
    done

    echo "${projects[@]}"
}

# 获取所有组
echo "获取所有组..."
encoded_groups=$(get_all_groups)

if [ -z "$encoded_groups" ]; then
    echo "未找到任何组。"
    exit 1
fi

# 遍历每个组
for encoded_group in $encoded_groups; do
    # 解码组信息
    _jq() {
        echo "$encoded_group" | base64 --decode | jq -r "$1"
    }

    group_id=$(_jq '.id')
    group_name=$(_jq '.name')

    # 创建组目录，使用组的完整路径以避免名称冲突
    group_path=$(_jq '.name')
    echo "处理组: $group_path (ID: $group_id)"

    mkdir -p "$group_path"
    cd "$group_path" || { echo "无法进入组目录 $group_path"; continue; }

    # 获取该组的所有项目
    projects=$(get_projects_of_group "$group_id")

    if [ -z "$projects" ]; then
        echo "组 $group_path 下没有项目。"
    else
        for repo_url in $projects; do
            repo_name=$(basename "$repo_url" .git)
            if [ -d "$repo_name" ]; then
                echo "仓库 $repo_name 已存在，跳过。"
            else
                echo "克隆仓库 $repo_name ..."
                git clone "$repo_url"
            fi
        done
    fi

    # 返回备份根目录
    cd "$BACKUP_DIR" || exit
done

echo "所有仓库已备份到 $BACKUP_DIR"
