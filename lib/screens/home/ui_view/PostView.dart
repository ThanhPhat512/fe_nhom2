import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/post_post.dart';

class PostView extends StatelessWidget {
  final List<Post> posts;
  final AnimationController animationController;
  final Animation<double> animation;

  const PostView({
    Key? key,
    required this.posts,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final post = posts[index];
                //String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(post.dateCreate);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: post.user.avatar != null
                                  ? NetworkImage(post.user.avatar!)
                                  : const AssetImage('assets/default_profile.png') as ImageProvider,
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.user.userName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   formattedDate,
                                //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          post.description ?? 'No description',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        post.image != null
                            ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post.image!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 300,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Text('Image failed to load')),
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

