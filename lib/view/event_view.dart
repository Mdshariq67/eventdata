import 'package:easemydealtask/view_model/event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: viewModel.selectedFilter,
                  items: const [
                    DropdownMenuItem(
                        value: 'Select Filter', child: Text('Select Filter')),
                    DropdownMenuItem(value: 'Week', child: Text('Week')),
                    DropdownMenuItem(value: 'Month', child: Text('Month')),
                    DropdownMenuItem(value: 'Date', child: Text('Date')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.updateFilter(value);
                      if (value == 'Week') {
                        viewModel.filterByWeek();
                      } else if (value == 'Month') {
                      } else {
                        viewModel.filterByDate();
                      }
                    }
                  },
                ),
              ),
              if (viewModel.selectedFilter == 'Week')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: viewModel.selectedWeekFilter,
                    items: const [
                      DropdownMenuItem(
                          value: 'Select Week', child: Text('Select Week')),
                      DropdownMenuItem(
                          value: 'This Week', child: Text('This Week')),
                      DropdownMenuItem(
                          value: 'Last Week', child: Text('Last Week')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.updateSelectedWeekFilter(value);
                      }
                    },
                  ),
                ),
              if (viewModel.selectedFilter == 'Month')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: viewModel.selectedMonth,
                    items: const [
                      DropdownMenuItem(
                          value: 'Select Month', child: Text('Select Month')),
                      DropdownMenuItem(
                          value: 'January', child: Text('January')),
                      DropdownMenuItem(
                          value: 'February', child: Text('February')),
                      DropdownMenuItem(value: 'March', child: Text('March')),
                      DropdownMenuItem(value: 'April', child: Text('April')),
                      DropdownMenuItem(value: 'May', child: Text('May')),
                      DropdownMenuItem(value: 'June', child: Text('June')),
                      DropdownMenuItem(value: 'July', child: Text('July')),
                      DropdownMenuItem(value: 'August', child: Text('August')),
                      DropdownMenuItem(
                          value: 'September', child: Text('September')),
                      DropdownMenuItem(
                          value: 'October', child: Text('October')),
                      DropdownMenuItem(
                          value: 'November', child: Text('November')),
                      DropdownMenuItem(
                          value: 'December', child: Text('December')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.updateSelectedMonth(value);
                        viewModel.filterBySelectedMonth();
                      }
                    },
                  ),
                ),
            ],
          ),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.error.isNotEmpty
                    ? Center(child: Text(viewModel.error))
                    : RefreshIndicator(
                        onRefresh: () => viewModel.fetchEvents(),
                        child: ListView.builder(
                          itemCount: viewModel.events.length,
                          itemBuilder: (context, index) {
                            final event = viewModel.events[index];
                            return ListTile(
                              title: Text(event.title),
                              subtitle: Text(event.description),
                              trailing: Text(
                                '${event.date.year}-${event.date.month}-${event.date.day}',
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
