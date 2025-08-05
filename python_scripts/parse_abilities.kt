import java.io.File
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import java.util.regex.Pattern
import javax.swing.JFileChooser
import kotlinx.serialization.*
import kotlinx.serialization.json.*

@Serializable
data class Entry(
    val title: String,
    val domain: String,
    val level: Int,
    val type: String,
    val recallCost: Int,
    val description: String
)

fun cleanMarkdown(content: String): String {
    return content
        .removePrefix("\uFEFF") // Rimuove BOM
        .lines()
        .map { it.removePrefix("> ").trim() }
        .filter { it.isNotBlank() }
        .joinToString("\n")
}

fun parseMarkdown(content: String): Entry? {
    val cleaned = cleanMarkdown(content)

    val titleRegex = Regex("^# (.+)", RegexOption.MULTILINE)
    val typeRegex = Regex("""\*\*Level (\d+) (\w+) (Ability|Spell|Grimoire)\*\*""")
    val recallRegex = Regex("""\*\*Recall Cost:\*\* (\d+)""")

    val title = titleRegex.find(cleaned)?.groupValues?.get(1)?.trim()?.replaceFirstChar { it.uppercase() }
        ?: return null
    val typeMatch = typeRegex.find(cleaned) ?: return null
    val recallCost = recallRegex.find(cleaned)?.groupValues?.get(1)?.toIntOrNull() ?: return null

    val level = typeMatch.groupValues[1].toInt()
    val domain = typeMatch.groupValues[2].capitalize()
    val type = typeMatch.groupValues[3].capitalize()

    val descriptionStart = cleaned.indexOf("**Recall Cost:**")
    val description = if (descriptionStart != -1) {
        cleaned.substring(descriptionStart).replace(Regex("""\*\*Recall Cost:\*\* \d+"""), "")
            .trim().replace("\n", " ")
    } else {
        ""
    }

    return Entry(
        title = title,
        domain = domain,
        level = level,
        type = type,
        recallCost = recallCost,
        description = description
    )
}

fun selectDirectory(): File? {
    val chooser = JFileChooser()
    chooser.dialogTitle = "Seleziona una cartella con file .md"
    chooser.fileSelectionMode = JFileChooser.DIRECTORIES_ONLY
    val result = chooser.showOpenDialog(null)
    return if (result == JFileChooser.APPROVE_OPTION) chooser.selectedFile else null
}

fun main() {
    val selectedDir = selectDirectory()
    if (selectedDir == null) {
        println("Nessuna cartella selezionata.")
        return
    }

    val json = Json { prettyPrint = true }

    selectedDir.listFiles { file -> file.extension.lowercase() == "md" }?.forEach { mdFile ->
        val content = mdFile.readText(StandardCharsets.UTF_8)
        val parsed = parseMarkdown(content)

        if (parsed != null) {
            val outputFile = File(mdFile.parentFile, mdFile.nameWithoutExtension + ".json")
            outputFile.writeText(json.encodeToString(parsed), Charsets.UTF_8)
            println("Creato: ${outputFile.name}")
        } else {
            println("Errore nel parsing: ${mdFile.name}")
        }
    }
}
