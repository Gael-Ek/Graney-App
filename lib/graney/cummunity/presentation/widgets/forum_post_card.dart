import 'package:flutter/material.dart';
import '../../domain/entities/forum_post_entity.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostEntity post;

  const ForumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(post.user[0]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${post.date.day}/${post.date.month}/${post.date.year}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    post.bloomType.displayName,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(post.content),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${post.comments}'),
                const Spacer(),
                const Icon(Icons.location_on, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '${post.location.latitude.toStringAsFixed(2)}, ${post.location.longitude.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
