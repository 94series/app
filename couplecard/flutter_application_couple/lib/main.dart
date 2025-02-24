import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class CardModel {
  final String title;
  final String description;
  final String type; // "任务卡", "愿望卡", "道具卡", 等等
  final int points; // 卡牌所需/奖励积分
  bool isCompleted;

  CardModel({
    required this.title,
    required this.description,
    required this.type,
    required this.points,
    this.isCompleted = false,
  });
}
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String taskName;
  final int progress; // 任务进度 0 到 100 的整数

  const TaskWidget({
    Key? key,
    required this.taskName,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(taskName),
        LinearProgressIndicator(
          value: progress / 100.0,
          backgroundColor: Colors.grey[300],
          color: progress == 100 ? Colors.green : Colors.blue,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../models/card.dart';
import '../widgets/card_widget.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardModel> cards = [
    CardModel(
      title: "共同做任务",
      description: "完成书籍共读任务，奖励10积分。",
      type: "任务卡",
      points: 10,
    ),
    CardModel(
      title: "浪漫之旅",
      description: "一同旅行，奖励50积分。",
      type: "愿望卡",
      points: 50,
    ),
    CardModel(
      title: "道具使用",
      description: "兑换一次免费的按摩服务。",
      type: "道具卡",
      points: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('情侣互动卡牌'),
      ),
      body: ListView(
        children: cards.map((card) {
          return CardWidget(
            card: card,
            onTap: () {
              // 点击卡牌后跳转到任务详情页
              if (card.type == "任务卡") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(card: card),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/card.dart';
import '../widgets/task_widget.dart';

class TaskScreen extends StatefulWidget {
  final CardModel card;

  const TaskScreen({Key? key, required this.card}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int progress = 0;

  void updateProgress() {
    setState(() {
      if (progress < 100) {
        progress += 20; // 每次点击进度增加20%
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.card.description),
            SizedBox(height: 20),
            TaskWidget(
              taskName: widget.card.title,
              progress: progress,
            ),
            ElevatedButton(
              onPressed: updateProgress,
              child: Text('完成一部分任务'),
            ),
            SizedBox(height: 10),
            if (progress == 100)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.card.isCompleted = true; // 任务完成
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('任务完成，获得 ${widget.card.points} 积分！')),
                  );
                },
                child: Text('完成任务'),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '情侣互动卡牌',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
