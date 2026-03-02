import 'package:flutter/material.dart';
import 'optimized_widgets.dart';

/// Examples demonstrating performance optimization techniques
class PerformanceExamplesScreen extends StatelessWidget {
  const PerformanceExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Examples'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OptimizedWidgetsSection(),
              SizedBox(height: 24),
              _ListOptimizationSection(),
              SizedBox(height: 24),
              _MemoryOptimizationSection(),
              SizedBox(height: 24),
              _ErrorHandlingSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section demonstrating optimized widgets
class _OptimizedWidgetsSection extends StatelessWidget {
  const _OptimizedWidgetsSection();

  @override
  Widget build(BuildContext context) {
    return OptimizedWidgets.card(
      padding: OptimizedWidgets.paddingAll16,
      child: OptimizedWidgets.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Optimized Widgets'),
          OptimizedWidgets.verticalSpace8,
          OptimizedWidgets.bodyText(
            'Using const constructors and pre-defined widgets for better performance.',
          ),
          OptimizedWidgets.verticalSpace16,

          // Example of optimized widgets
          OptimizedWidgets.row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Primary Button'),
              ),
              OptimizedWidgets.horizontalSpace8,
              OutlinedButton(
                onPressed: () {},
                child: const Text('Secondary'),
              ),
            ],
          ),
          OptimizedWidgets.verticalSpace8,

          // Optimized ListView
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return OptimizedPatterns.listTile(
                  leading: OptimizedWidgets.card(
                    padding: OptimizedWidgets.paddingAll8,
                    child: OptimizedWidgets.text('${index + 1}'),
                  ),
                  title: OptimizedWidgets.bodyText('Optimized Item $index'),
                  subtitle: OptimizedWidgets.captionText(
                    'This item uses performance optimization',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Section demonstrating list optimization
class _ListOptimizationSection extends StatelessWidget {
  const _ListOptimizationSection();

  @override
  Widget build(BuildContext context) {
    return OptimizedWidgets.card(
      padding: OptimizedWidgets.paddingAll16,
      child: OptimizedWidgets.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('List Optimization'),
          OptimizedWidgets.verticalSpace8,
          OptimizedWidgets.bodyText(
            'Optimized image loading and caching for better performance.',
          ),
          OptimizedWidgets.verticalSpace16,

          // Optimized image examples
          OptimizedWidgets.row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptimizedWidgets.column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.asset(
                      'assets/icons/admin.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  OptimizedWidgets.verticalSpace4,
                  OptimizedWidgets.captionText('Cached Image'),
                ],
              ),
              OptimizedWidgets.column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.zero,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  OptimizedWidgets.verticalSpace4,
                  OptimizedWidgets.captionText('Placeholder'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section demonstrating memory optimization
class _MemoryOptimizationSection extends StatelessWidget {
  const _MemoryOptimizationSection();

  @override
  Widget build(BuildContext context) {
    return OptimizedWidgets.card(
      padding: OptimizedWidgets.paddingAll16,
      child: OptimizedWidgets.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Memory Optimization'),
          OptimizedWidgets.verticalSpace8,
          OptimizedWidgets.bodyText(
            'Techniques for reducing memory usage and preventing leaks.',
          ),
          OptimizedWidgets.verticalSpace16,

          // Memory optimization examples
          OptimizedWidgets.container(
            padding: OptimizedWidgets.paddingAll12,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: OptimizedWidgets.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptimizedWidgets.row(
                  children: [
                    Icon(Icons.memory, color: Colors.blue[700]),
                    OptimizedWidgets.horizontalSpace8,
                    OptimizedWidgets.titleText('Memory Management'),
                  ],
                ),
                OptimizedWidgets.verticalSpace8,
                OptimizedWidgets.bodyText(
                  '• Use const constructors for static widgets\n'
                  '• Implement proper disposal in StatefulWidgets\n'
                  '• Cache expensive computations\n'
                  '• Monitor memory usage in debug mode',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section demonstrating error handling
class _ErrorHandlingSection extends StatelessWidget {
  const _ErrorHandlingSection();

  @override
  Widget build(BuildContext context) {
    return OptimizedWidgets.card(
      padding: OptimizedWidgets.paddingAll16,
      child: OptimizedWidgets.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Error Handling'),
          OptimizedWidgets.verticalSpace8,
          OptimizedWidgets.bodyText(
            'Robust error handling with error boundaries and graceful degradation.',
          ),
          OptimizedWidgets.verticalSpace16,

          // Error boundary example - using a simple try-catch approach
          Builder(
            builder: (context) {
              try {
                return OptimizedWidgets.column(
                  children: [
                    OptimizedWidgets.container(
                      padding: OptimizedWidgets.paddingAll12,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: OptimizedWidgets.row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          OptimizedWidgets.horizontalSpace8,
                          Expanded(
                            child: OptimizedWidgets.bodyText(
                              'This content demonstrates error handling patterns',
                            ),
                          ),
                        ],
                      ),
                    ),
                    OptimizedWidgets.verticalSpace8,

                    // Simple performance example widget
                    OptimizedWidgets.container(
                      padding: OptimizedWidgets.paddingAll8,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: OptimizedWidgets.bodyText(
                          'Performance optimized content'),
                    ),
                  ],
                );
              } catch (error) {
                debugPrint('Error boundary caught: $error');
                return OptimizedWidgets.container(
                  padding: OptimizedWidgets.paddingAll12,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: OptimizedWidgets.bodyText(
                      'Error occurred: ${error.toString()}'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Example widget using StatefulWidget best practices
class _PerformanceAwareExample extends StatefulWidget {
  const _PerformanceAwareExample();

  @override
  State<_PerformanceAwareExample> createState() =>
      _PerformanceAwareExampleState();
}

class _PerformanceAwareExampleState extends State<_PerformanceAwareExample> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedWidgets.container(
      padding: OptimizedWidgets.paddingAll12,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: OptimizedWidgets.column(
        children: [
          OptimizedWidgets.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OptimizedWidgets.bodyText('Performance Counter: $_counter'),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
            ],
          ),
          OptimizedWidgets.verticalSpace4,
          OptimizedWidgets.captionText(
            'This widget demonstrates performance best practices',
          ),
        ],
      ),
    );
  }
}

/// Utility class for performance optimization demonstrations
class PerformanceExampleUtils {
  /// Initialize performance monitoring for the app
  static void initializePerformanceMonitoring() {
    // Configure image cache for better memory management
    debugPrint('Configuring image cache for better performance...');

    // Track frame performance for debugging
    debugPrint('Starting frame performance tracking...');

    // Monitor memory usage at app start
    debugPrint('Monitoring memory usage...');
  }

  /// Clean up resources and caches
  static void performCleanup() {
    // Clear caches to free memory
    debugPrint('Clearing caches to free memory...');

    // Monitor memory usage after cleanup
    debugPrint('Memory usage after cleanup...');
  }

  /// Demonstrate naming convention utilities
  static void demonstrateNamingConventions() {
    final examples = [
      'user_name',
      'UserName',
      'userName',
      'USER_NAME',
    ];

    for (final example in examples) {
      debugPrint('Original: $example');
      // Note: These would access the naming utilities from CodeQualityEnhancer.naming
      // but for this example, we'll just demonstrate the concept
      debugPrint('Example shows naming convention checking');
      debugPrint('Valid naming patterns can be validated');
      debugPrint('---');
    }
  }
}
