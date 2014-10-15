def save_comment(id, name, message)
  comment = create_comment(id, name, message)
  get_comments_for(id).merge!(comment)
  save_all_data
end

def create_comment(id, name, message)
  {
      SecureRandom.hex(2) => {
          'id' => id,
          'name' => name,
          'message' => message
      }
  }
end

def delete_comment(id, parent)
  p id
  p parent
  p get_comments_for(parent).delete(id)
  save_all_data
end

def get_comments_for(id)
  get_comments[id] || get_comments[id] = {}
end

def get_comment_count
  get_comments.length
end

def get_comments
  $commentsStorage || $commentsStorage = {}
end
