package com.mydomain.homescreen_widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.SizeF
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class QuoteWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {

        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)

            val pendingIntent: PendingIntent = PendingIntent.getActivity(
                /* context = */ context,
                /* requestCode = */  0,
                /* intent = */ Intent(context, MainActivity::class.java),
                /* flags = */ PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val smallView = RemoteViews(context.packageName, R.layout.quote_widget_small).apply {
                val title = widgetData.getString("appwidget_text", null)
                setTextViewText(R.id.appwidget_text_small, title ?: "Be a one trick unicorn.")
                setOnClickPendingIntent(R.id.appwidget_text_small, pendingIntent)
            }
            val normalView = RemoteViews(context.packageName, R.layout.quote_widget).apply {
                val title = widgetData.getString("appwidget_text", null)
                setTextViewText(R.id.appwidget_text, title ?: "Be a one trick unicorn.")
                setOnClickPendingIntent(R.id.appwidget_text, pendingIntent)
            }

            val viewMapping: Map<SizeF, RemoteViews> = mapOf(
                SizeF(40f, 110f) to smallView,
                SizeF(40f, 220f) to normalView
            )

            val views = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                RemoteViews(viewMapping)
            } else {
                // Default to normal view if dynamic is not supported
                RemoteViews(context.packageName, R.layout.quote_widget)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}