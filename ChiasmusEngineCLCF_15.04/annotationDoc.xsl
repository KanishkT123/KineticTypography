<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">



<xsl:for-each select="output/weights/feature">
<xsl:value-of select="." />:<xsl:value-of select="./@weight" />
<xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:for-each select="output/tie/chiasm">
					====*<xsl:value-of select="./@position" />*====+<xsl:value-of select="./@annotation" />
					  
1. <xsl:text disable-output-escaping="yes">></xsl:text><xsl:value-of select="./wA" />
<xsl:text disable-output-escaping="yes"> ></xsl:text><xsl:value-of select="./wB" />
2. <xsl:value-of select="./extract" />
3. <xsl:value-of select="./context" />
4. <xsl:value-of select="../@rank" />
<xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
