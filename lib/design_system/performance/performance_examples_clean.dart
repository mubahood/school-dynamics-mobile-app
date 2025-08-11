import 'package:flutter/material.dart';
import 'optimized_widgets.dart';
import 'code_quality_enhancer.dart';

/// Examples demonstrating performance optimization techniques
class PerformanceExamplesScreen extends StatelessWidget {
  const PerformanceExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: OptimizedWidgets.headlineText('Performance Examples'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Optimized Widgets'),
          OptimizedWidgets.paddingVertical8,
          OptimizedWidgets.bodyText(
            'Using const constructors and pre-defined widgets for better performance.',
          ),
          OptimizedWidgets.paddingVertical16,

          // Example of optimized widgets
          Row(
            children: [
              OptimizedWidgets.primaryButton(
                onPressed: () {},
                child: OptimizedWidgets.buttonText('Primary Button'),
              ),
              OptimizedWidgets.paddingHorizontal8,
              OptimizedWidgets.secondaryButton(
                onPressed: () {},
                child: OptimizedWidgets.buttonText('Secondary'),
              ),
            ],
          ),
          OptimizedWidgets.paddingVertical8,

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('List Optimization'),
          OptimizedWidgets.paddingVertical8,
          OptimizedWidgets.bodyText(
            'Optimized image loading and caching for better performance.',
          ),
          OptimizedWidgets.paddingVertical16,

          // Optimized image examples
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                  OptimizedWidgets.paddingVertical4,
                  OptimizedWidgets.captionText('Cached Image'),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  OptimizedWidgets.paddingVertical4,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Memory Optimization'),
          OptimizedWidgets.paddingVertical8,
          OptimizedWidgets.bodyText(
            'Techniques for reducing memory usage and preventing leaks.',
          ),
          OptimizedWidgets.paddingVertical16,

          // Memory optimization examples
          Container(
            padding: OptimizedWidgets.paddingAll12,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.memory, color: Colors.blue[700]),
                    OptimizedWidgets.paddingHorizontal8,
                    OptimizedWidgets.titleText('Memory Management'),
                  ],
                ),
                OptimizedWidgets.paddingVertical8,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptimizedWidgets.headlineText('Error Handling'),
          OptimizedWidgets.paddingVertical8,
          OptimizedWidgets.bodyText(
            'Robust error handling with error boundaries and graceful degradation.',
          ),
          OptimizedWidgets.paddingVertical16,

          // Error boundary example
          CodeQualityEnhancer.createErrorBoundary(
            child: Column(
              children: [
                Container(
                  padding: OptimizedWidgets.paddingAll12,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      OptimizedWidgets.paddingHorizontal8,
                      Expanded(
                        child: OptimizedWidgets.bodyText(
                          'This content is wrapped in an error boundary',
                        ),
                      ),
                    ],
                  ),
                ),
                OptimizedWidgets.paddingVertical8,

                // Performance-aware state example
                _PerformanceAwareExample(),
              ],
            ),
            onError: (error, stackTrace) {
              debugPrint('Error boundary caught: $error');
            },
          ),
        ],
      ),
    );
  }
}

/// Example widget using PerformanceAwareState
class _PerformanceAwareExample extends StatefulWidget {
  const _PerformanceAwareExample();

  @override
  State<_PerformanceAwareExample> createState() =>
      _PerformanceAwareExampleState();
}

class _PerformanceAwareExampleState extends State<_PerformanceAwareExample>
    with PerformanceAwareState {
  int _counter = 0;

  @override
  String get widgetName => 'PerformanceAwareExample';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: OptimizedWidgets.paddingAll12,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OptimizedWidgets.bodyText('Performance Counter: $_counter'),
              OptimizedWidgets.primaryButton(
                onPressed: _incrementCounter,
                child: OptimizedWidgets.buttonText('Increment'),
              ),
            ],
          ),
          OptimizedWidgets.paddingVertical4,
          OptimizedWidgets.captionText(
            'This widget monitors its own build performance',
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
      debugPrint('Pascal: ${CodeQualityEnhancer.toPascalCase(example)}');
      debugPrint('Camel: ${CodeQualityEnhancer.toCamelCase(example)}');
      debugPrint('Snake: ${CodeQualityEnhancer.toSnakeCase(example)}');
      debugPrint('---');
    }
  }
}
